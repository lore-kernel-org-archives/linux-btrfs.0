Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:52225 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754038AbdJRLgE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Oct 2017 07:36:04 -0400
Received: by mail-io0-f172.google.com with SMTP id f20so5830143ioj.9
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Oct 2017 04:36:04 -0700 (PDT)
Subject: Re: Best strategie to remove devices from pool
To: Cloud Admin <admin@cloud.haefemeier.eu>, linux-btrfs@vger.kernel.org
References: <1508263135.2887.1.camel@cloud.haefemeier.eu>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <25c8ae16-78b0-07d7-0ff5-095460d8b1b0@gmail.com>
Date: Wed, 18 Oct 2017 07:36:01 -0400
MIME-Version: 1.0
In-Reply-To: <1508263135.2887.1.camel@cloud.haefemeier.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-17 13:58, Cloud Admin wrote:
> Hi,
> I want to remove two devices from a BTRFS RAID 1 pool. It should be
> enough free space to do it, but what is the best strategie. Remove both
> device in one call 'btrfs dev rem /dev/sda1 /dev/sdb1' (for example) or
> should it be better in two separate calls? What is faster? Are there
> other constraints to think about?
Ideally, delete them all with a single operation.  Internally the delete 
command uses some numeric trickery together with a balance operation to 
migrate the data off of the devices being removed.  If you do them one 
at a time, you will end up moving at least some data twice, and thus 
wasting time.  Other than that, there's not much to worry ab out, though 
keep in mind that deleting devices from an array can take a long time, 
especially if the array is mostly full.
