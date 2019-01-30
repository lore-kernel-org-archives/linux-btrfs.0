Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A6FC282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 12:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4BED2175B
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 12:58:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DCCXYkPP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbfA3M6G (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 07:58:06 -0500
Received: from mail-it1-f179.google.com ([209.85.166.179]:40856 "EHLO
        mail-it1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfA3M6G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 07:58:06 -0500
Received: by mail-it1-f179.google.com with SMTP id h193so10287323ita.5
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 04:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=cyFyOmZTP84540e3jYhA5i02OJr9SgDFZcNDFE0Lw14=;
        b=DCCXYkPPNn8bP+RMRjkmqE8ONHtBEYZIe5YEq8ORd0M9DR3NlalXUKhTKZ6XM/xmxX
         mAWHdFFqiqRUUaQzJ3Ug/s2SFX7FhrHzPeZiMTt2KzK7k9H6GvEDiibaT+WI/b2acqcH
         7jmSfpCHMsra2eJf0DN4rPPX6nEsI25wdMM4K23P7+zInacZ1A1bWfGEQ0dhqIunD+Zh
         oFmqThXNXZLRx0VXCY7iqCIASV6hL863Xq+rxBM2c4/paEAJHSYW57qAMB4lx0ZcPFyx
         uWvi0DeX6q+uwWIwiNY2r+0k8BFtzCT/+maT1q8qrqTYw5Y0zFPpf5CSYvyuH+cWvzIS
         ZUlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cyFyOmZTP84540e3jYhA5i02OJr9SgDFZcNDFE0Lw14=;
        b=E0efrdR3ecPWsBTfSZOGeeHEollSiBT1pZ2Rdfo9jIFCBtxTCs6JmhvmsUabZ9tup+
         eodfXrWN5vF8flmWh8bONFqJkQsO4rVoPTNRBviB5KlkMtta6RhZ7xzOVr48ihdtKQ2j
         IB6rgomTBA7MJ6Oubf8nR50HgWqpAxsogSKs0hW6/apXh4FsDYX5d0MDTfmIRdcGwfPq
         jOdECU6HnSQ8m6Bcw6KpRashYWdsgTMFzldmFrUyYux3VeeqBT+ChIeGqDfgCFPkMQ5y
         nLiAKAgytLO38d0bkRG+qDAtwli+h3c07+xE8aZNFReqc2CqU9aAsBMVa2wB5DOUoTla
         YtDA==
X-Gm-Message-State: AJcUukeStW4is57wF1TqkFUEwOc0DeIl6WueyH7xiU890Z52PzsLvK9y
        e0FZAik202VUNtOKs4TeNp7L1jsFP1A=
X-Google-Smtp-Source: ALg8bN5YUX0L+YmZpMMt3GKOrM8A63h3xarijoOLuqAnULHdRPBGE9q0nwRaycTLBge//duuD3qQ0A==
X-Received: by 2002:a24:a141:: with SMTP id n1mr11521211iti.31.1548853084232;
        Wed, 30 Jan 2019 04:58:04 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id d128sm686715iof.37.2019.01.30.04.58.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 04:58:03 -0800 (PST)
Subject: Re: dm-integrity + mdadm + btrfs = no journal?
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <2a321782-d258-1ef3-8d25-149b8e24e819@mendix.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5c11b6a4-de3d-2ba0-c5c6-65ea04cd0245@gmail.com>
Date:   Wed, 30 Jan 2019 07:58:00 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <2a321782-d258-1ef3-8d25-149b8e24e819@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-01-29 18:15, Hans van Kranenburg wrote:
> Hi,
> 
> Thought experiment time...
> 
> I have an HP z820 workstation here (with ECC memory, yay!) and 4x250G
> 10k SAS disks (and some spare disks). It's donated hardware, and I'm
> going to use it to replace the current server in the office of a
> non-profit organization (so it's not work stuff this time).
> 
> The machine is going to run Debian/Xen and a few virtual machines
> (current one also does, but the hardware is now really starting to fall
> apart).
> 
> I have been thinking a bit how to (re)organize disk storage in this
> scenario.
> 
> 1. Let's use btrfs everywhere. \:D/
> 2. For running Xen virtual machines, I prefer block devices on LVM. No
> image files, no btrfs-on-btrfs etc...
> 3. Oh, and there's also 1 MS Windows VM that will be in the mix.
> 
> Obviously I can't start using multi-device btrfs in each and every
> virtual machine (a big pile of horror when one disk dies or starts
> misbehaving).
> 
> So, what I was thinking of is:
> 
> * Use dm-integrity on partitions on the individual disks
> * Use mdadm RAID10 on top (which is then able to repair bitrot)
> * Use LVM on top
> * Etc...
> 
> For all of the filesystems, I would be doing backups to a remote
> location outside of the building with send/receive.
> 
> The Windows VM will be an image file on a btrfs filesystem in the Xen
> dom0. It's idle most of the time, and I think cow+autodefrag can easily
> handle it. I'd like to be able to take snapshots of it which can be sent
> to a remote location.
I would suggest against this.  NTFS is a pathologically bad case even 
when using it from inside Linux and leaving it almost completely idle. 
When used from Windows, it has horrible performance and trashes 
performance of _all_ other VM images on the same disk.

Also, just in general, I've only seen at best mediocre results from 
using BTRFS for VM image storage when using Xen.  I'm not sure exactly 
why, but I think it has something to do with how the Xen block backend 
access the filesystem.
> 
> Now, to finally throw in the big question: If I use btrfs everywhere,
> can I run dm-integrity without a journal?
> 
> As far as I can reason about.. I could. As long as there's no 'nocow'
> happening, the only thing that needs to happen correctly is superblock
> writes, right?
Running dm-integrity without a journal is roughly equivalent to using 
the nobarrier mount option (the journal is used to provide the same 
guarantees that barriers do).  IOW, don't do this unless you are willing 
to lose the whole volume.
