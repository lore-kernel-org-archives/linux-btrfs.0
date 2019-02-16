Return-Path: <SRS0=6oD6=QX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F776C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 17:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 033F42192B
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 17:05:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="RlvZGdI0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfBPRFn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Feb 2019 12:05:43 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41377 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfBPRFn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Feb 2019 12:05:43 -0500
Received: by mail-ot1-f66.google.com with SMTP id t7so5401109otk.8
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Feb 2019 09:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E5oU+8OGWfNcbFFs3SOhhw6G8UO44WCYyxqkkn/iCiA=;
        b=RlvZGdI0Xmjp/x40FV4IXDsNu9zn/tpczpkPTwGMfS4SNYVlks8zEf7KNUteuPEjky
         FEhikT7DFgVH1xK2raUXdRoYjNKvUQFrbdIWIZ5gJu09Ee4JtcpZSIH/M+8iVmZAC4q7
         IP/T+JoQDg+qHDt3Rsl4PmcsndDrg67EoHjjw5coPqgU1cWChSTjTEfG8gGxmKWL7pqH
         /Dqbhk706Ox5wbz4oGHnDAV50W+VZ8nf104P1dLD/rq0qzJIxc4w+sqMoL7ynLBVm/SC
         WyCqXw0Q15tI9esePgb+ItKYXFkB3IVvJbcLjlkGDiKB/41voQhpTVJ1QoVBV+I6FG+g
         GrdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E5oU+8OGWfNcbFFs3SOhhw6G8UO44WCYyxqkkn/iCiA=;
        b=UJnlJeW3Mc4X/S0F9e8sz3QgleNpo3e86vRm6Jfa+QElZ1RR49p2OHHcGQC2lkneW4
         fLKuQuzrBnqqDXUqvNVVrY0UBH9kwd4hobmNco/ci1ueFtNCyG84VhtuQs5h4FwO8Idj
         6cWOsHYFXVjuGym+NEkZv1rQX33X2Ib7vt69ZujY60zJDLvX62vmQMiu2ipuvb4xha8a
         bvJJs+XII26FlYXx5EfAOYyTE9WFNsDTYrUZyYuMEYLkygYJ3Uj74tNcwEwqhhR2rqNY
         ++DBasqr3rTtzbUaNelU5qcBQjbR/49lNOflV2sCtEXFfiBXQHWNx6rfTDzsoM/FXIlV
         Us/Q==
X-Gm-Message-State: AHQUAuYPn6kQwg+YrJsNQSggormTODJriFOpXZTAjiaEeLKh3HwVmYh0
        BHj5s1xtR5K47Ie7q5+kXBi0BFh9xzfB01GNJaJbdA==
X-Google-Smtp-Source: AHgI3IYyZ0wumcjTfYgSq+CjMP8M0nxipsFzA4By+4DUlvx6zlqWN11pOaw6lB7UQ8w9nbAjUtxGhgyT+MnbAKjrpZw=
X-Received: by 2002:aca:cc0f:: with SMTP id c15mr10317703oig.105.1550336742379;
 Sat, 16 Feb 2019 09:05:42 -0800 (PST)
MIME-Version: 1.0
References: <20190215095710.GA12279@linux-x5ow.site> <20190216053133.GT20493@dastard>
 <20190216053957.GU20493@dastard>
In-Reply-To: <20190216053957.GU20493@dastard>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Sat, 16 Feb 2019 09:05:31 -0800
Message-ID: <CAPcyv4jkT5i=akskXCzS7ST47iEk=x8Oh84Cp7q+WRpdOX8hGg@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Software RAID Support for NV-DIMM
To:     Dave Chinner <david@fromorbit.com>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lsf-pc@lists.linux-foundation.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 15, 2019 at 9:40 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Sat, Feb 16, 2019 at 04:31:33PM +1100, Dave Chinner wrote:
> > On Fri, Feb 15, 2019 at 10:57:12AM +0100, Johannes Thumshirn wrote:
> > > (This is a joint proposal with Hannes Reinecke)
> > >
> > > Servers with NV-DIMM are slowly emerging in data centers but one key feature
> > > for reliability of these systems hasn't been addressed up to now, data
> > > redundancy.
> > >
> > > While it would be best to solve this issue in the memory controller of the CPU
> > > itself, I don't see this coming in the next few years. This puts us as the OS
> > > in the burden to create the redundant copies of data for the users.
> > >
> > > If we leave of the DAX support Linux' software RAID implementations (MD,
> > > device-mapper and BTRFS RAID) do already work on top of pmem devices, but they
> > > are incompatible with DAX.
> > >
> > > In this session Hannes and I would like to discuss eventual ways how we as an
> > > operating system can mitigate these issues for our users.
> >
> > We've supported this since mid 2018 and commit ba23cba9b3bd ("fs:
> > allow per-device dax status checking for filesystems"). That is,
> > we can have DAX on the XFS RT device indepently of the data device.
> >
> > That is, you set up pmem in three segments - two small identical
> > segments start get mirrored with RAID1 as the data device, and
> > the remainder as a block device that is dax capable set up as the
> > XFS realtime device. Set the RTINHERIT bit on the root directory at
> > mkfs time ("-d rtinherit=1") and then all the data goes to the DAX
> > capable realtime device, and all the metadata goes to the software
> > raided pmem block devices that aren't DAX capable.
> >
> > Problem already solved, yes?
>
> Sorry, this was meant to be a reply to Dan's email commenting about
> some people needing mirrored metadata, not the parent that was
> talking about whole device RAID...
>
> i.e. mirrored metadata w/ FS-DAX for data should already be a solved
> problem...

Ah true, thanks for the clarification. I'll give it a try, the last
time I looked RT configurations failed with DAX, but perhaps that's
been fixed and I can drop if from my list of broken DAX items.
