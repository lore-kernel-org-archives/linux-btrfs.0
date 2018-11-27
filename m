Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F7AC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 20:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42A0A2086B
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 20:08:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="PJRLC7VB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42A0A2086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbeK1HHM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 02:07:12 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34986 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbeK1HHM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 02:07:12 -0500
Received: by mail-qt1-f196.google.com with SMTP id v11so23255740qtc.2
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 12:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=30PrvaKwktmd3vrzWIt0d9+j5WbYaEL1vuLpjzdinh4=;
        b=PJRLC7VBW5wYHyh+XFx1JtTsty+4teWox42zDlW7S06/eU8rOBG37xhMn0SBIK8CMB
         2a9M1TXcKBHkIwADTOXDRTLLdhCbycQx2ApYp+9bz7/Gi0eFMGfUsFVal8r08JmJKNep
         K2kviOdxc3rG7jHGdz7pC3cG22qIvhKZTBl8uq8+4oEzPRfsygHvIW1JaUCWkzjwyLyR
         kbPtK6eNq5S6AILq1BGRNradrnTUBH/DwdtFMXGzLNE1MsEBy2E3G72rRq4hMirnXgxk
         Yk2Evisz5T1Di9aMrJwbRNJz5S9v3KmNxNqxbK/75ZT5bnhCw9i8Lpb7lXXA4u+VQipL
         vn9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=30PrvaKwktmd3vrzWIt0d9+j5WbYaEL1vuLpjzdinh4=;
        b=puKTJCKJ74T/bgG8LTA0rqVdE8TCe2lLbEDxKKC5HGDMZj3L8ZA8a7CakuJiB1KkeW
         R1lQev6hJP7se07OP/MSQCnajFRXLAueV9UNL1DF1D8EyblKHC/hY8UcArbYHJUToyBE
         aYi+MQ7ed5Y3OmO9iUvnuqkMwchIqaqTaHSpM67QSJBiILFR9c0SsyOee7JAjYegOS18
         khKbT0htTZdUNq3aIWCvQhsI3JD7JdDHWd9MEMB3HtYHm5H35Oe9Fk8hsHi++yfk76nJ
         kpVo9KpwJpgjihqs5ai8HUQCo8CeJmlpWuHrlK2Oid/fAIUxJgoD/hljUNIbHJbZMaSb
         wvmw==
X-Gm-Message-State: AA+aEWb7S9nlQgWftYrUU1/U+chO+yOOfNLmDUq5O5tVDcyEJQuL+xsq
        mskpaRST4gm9XNIostVPaqZFNB+nncU=
X-Google-Smtp-Source: AFSGD/VrV4wRPL82vgUPWaNe/vl/3Oo8RVaOPHVrmtRJdHfs4wyIy7s/VBOGkRJYV0pEgDW95XPL5g==
X-Received: by 2002:a0c:bd15:: with SMTP id m21mr32576304qvg.57.1543349290332;
        Tue, 27 Nov 2018 12:08:10 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:4c40])
        by smtp.gmail.com with ESMTPSA id t140sm2105445qke.6.2018.11.27.12.08.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Nov 2018 12:08:09 -0800 (PST)
Date:   Tue, 27 Nov 2018 15:08:08 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Chris Mason <clm@fb.com>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH 2/3] btrfs: wakeup cleaner thread when adding delayed iput
Message-ID: <20181127200807.bdnvwap2kuuwuarg@macbook-pro-91.dhcp.thefacebook.com>
References: <20181121190922.25038-1-josef@toxicpanda.com>
 <20181121190922.25038-3-josef@toxicpanda.com>
 <4e8aad56-42e2-d666-c909-d5d058b799c9@suse.com>
 <20181127195450.fjor2gewhp3hri56@macbook-pro-91.dhcp.thefacebook.com>
 <13D3592A-3719-4F9E-8E8A-944FE88F30D4@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13D3592A-3719-4F9E-8E8A-944FE88F30D4@fb.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 07:59:42PM +0000, Chris Mason wrote:
> On 27 Nov 2018, at 14:54, Josef Bacik wrote:
> 
> > On Tue, Nov 27, 2018 at 10:26:15AM +0200, Nikolay Borisov wrote:
> >>
> >>
> >> On 21.11.18 г. 21:09 ч., Josef Bacik wrote:
> >>> The cleaner thread usually takes care of delayed iputs, with the
> >>> exception of the btrfs_end_transaction_throttle path.  The cleaner
> >>> thread only gets woken up every 30 seconds, so instead wake it up to 
> >>> do
> >>> it's work so that we can free up that space as quickly as possible.
> >>
> >> Have you done any measurements how this affects the overall system. I
> >> suspect this introduces a lot of noise since now we are going to be
> >> doing a thread wakeup on every iput, does this give a chance to have
> >> nice, large batches of iputs that  the cost of wake up can be 
> >> amortized
> >> across?
> >
> > I ran the whole patchset with our A/B testing stuff and the patchset 
> > was a 5%
> > win overall, so I'm inclined to think it's fine.  Thanks,
> 
> It's a good point though, a delayed wakeup may be less overhead.

Sure, but how do we go about that without it sometimes messing up?  In practice
the only time we're doing this is at the end of finish_ordered_io, so likely to
not be a constant stream.  I suppose since we have places where we force it to
run that we don't really need this.  IDK, I'm fine with dropping it.  Thanks,

Josef
