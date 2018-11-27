Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 973EFC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 13:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4987A20989
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 13:10:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4987A20989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbeK1AIF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 19:08:05 -0500
Received: from dibed.net-space.pl ([84.10.22.86]:41307 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbeK1AIF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 19:08:05 -0500
Received: from router-fw.i.net-space.pl ([192.168.52.1]:37484 "EHLO
        tomti.i.net-space.pl") by router-fw-old.i.net-space.pl with ESMTP
        id S1876755AbeK0NJv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 14:09:51 +0100
X-Comment: RFC 2476 MSA function at dibed.net-space.pl logged sender identity as: dkiper
Date:   Tue, 27 Nov 2018 14:09:48 +0100
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Nick Terrell <terrelln@fb.com>
Cc:     David Sterba <dsterba@suse.cz>, Kernel Team <Kernel-team@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>
Subject: Re: [PATCH v7 0/2] btrfs: Add zstd support to grub btrfs
Message-ID: <20181127130948.hjktrautuxc6ql5b@tomti.i.net-space.pl>
References: <20181119192008.3496427-1-terrelln@fb.com>
 <20181119203412.rsd2wbx7nc7enpax@tomti.i.net-space.pl>
 <4AA367FE-A601-4F1D-A37B-F85F86D31E94@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA367FE-A601-4F1D-A37B-F85F86D31E94@fb.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 02:55:33AM +0000, Nick Terrell wrote:
> > On Nov 19, 2018, at 12:34 PM, Daniel Kiper <dkiper@net-space.pl> wrote:
> > On Mon, Nov 19, 2018 at 11:20:06AM -0800, Nick Terrell wrote:
> >> Hi all,
> >>
> >> This patch set imports the upstream zstd library, adds zstd support to the
> >> btrfs module, and adds a test case. I've also tested the patch set by storing
> >> my boot partition in btrfs with and without zstd compression and rebooting.
> >
> > LGTM. I will apply both patches in a week or so.
> >
> > Thank you for doing the work.
> >
> > Daniel
>
>
> Thanks for taking the time to review and merge the patches, and for
> maintaining GRUB!

You are welcome!

Daniel
