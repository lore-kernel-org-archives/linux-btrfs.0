Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD68C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 13:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAF622081C
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 13:30:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EAF622081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbeLDNaO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 08:30:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:39286 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725770AbeLDNaO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 08:30:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5F8E7AD93;
        Tue,  4 Dec 2018 13:30:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6A5D5DAC39; Tue,  4 Dec 2018 14:29:52 +0100 (CET)
Date:   Tue, 4 Dec 2018 14:29:52 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Chris Mason <clm@fb.com>, Jean Fobe <jeanfobe@ime.usp.br>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs development - question about crypto api integration
Message-ID: <20181204132952.GP17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Chris Mason <clm@fb.com>, Jean Fobe <jeanfobe@ime.usp.br>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CAMHc_wN+-qHc1+q6fuRCzzJ9fsE2-vwa5N3031ANpZ8+tXb7WQ@mail.gmail.com>
 <8db22a5b-14de-3e8a-241f-d7e963ea5a57@suse.com>
 <017BD22D-F708-4DBA-B977-78AFCCF58D0F@fb.com>
 <694b5ea4-d177-f1e2-3f7a-6ece6cbc8ed4@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <694b5ea4-d177-f1e2-3f7a-6ece6cbc8ed4@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 30, 2018 at 06:27:58PM +0200, Nikolay Borisov wrote:
> 
> 
> On 30.11.18 г. 17:22 ч., Chris Mason wrote:
> > On 29 Nov 2018, at 12:37, Nikolay Borisov wrote:
> > 
> >> On 29.11.18 г. 18:43 ч., Jean Fobe wrote:
> >>> Hi all,
> >>>     I've been studying LZ4 and other compression algorithms on the
> >>> kernel, and seen other projects such as zram and ubifs using the
> >>> crypto api. Is there a technical reason for not using the crypto api
> >>> for compression (and possibly for encryption) in btrfs?
> >>>     I did not find any design/technical implementation choices in
> >>> btrfs development in the developer's FAQ on the wiki. If I completely
> >>> missed it, could someone point me in the right direction?
> >>>     Lastly, if there is no technical reason for this, would it be
> >>> something interesting to have implemented?
> >>
> >> I personally think it would be better if btrfs' exploited the generic
> >> framework. And in fact when you look at zstd, btrfs does use the
> >> generic, low-level ZSTD routines but not the crypto library wrappers. 
> >> If
> >> I were I'd try and convert zstd (since it's the most recently added
> >> algorithm) to using the crypto layer to see if there are any lurking
> >> problems.
> > 
> > Back when I first added the zlib support, the zlib API was both easier 
> > to use and a better fit for our async worker threads.  That doesn't mean 
> > we shouldn't switch, it's just how we got to step one ;)
> 
> And what about zstd? WHy is it also using the low level api and not the
> crypto wrappers?

I think beacuse it just copied the way things already were.

Here's fs/ubifs/compress.c as an example use of the API in a filesystem:

ubifs_compress
  crypto_comp_compress
    crypto_comp_crt -- address of, dereference
    ->cot_commpress -- takes another address of something, indirect
		       function call
      with value 'crypto_compress'
	-- this does 2 pointer dereferences and indirect call to
	   coa_compress
	   coa_compress = lzo_compress
	     lzo_compress -- pointer dereferences for crypto context
	       lzo1x_1_compress -- through static __lzo_compress (no overhead)

while in btrfs:

btrfs_compress_pages
  ->compress_pages
    lzo1x_1_compress

The crypto API adds several pointer and function call indirectinos, I'm
not sure I want to get rid of the direct calls just yet.
