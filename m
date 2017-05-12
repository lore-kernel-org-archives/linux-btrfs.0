Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34355 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751811AbdELLQg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 May 2017 07:16:36 -0400
Received: by mail-io0-f173.google.com with SMTP id k91so38033720ioi.1
        for <linux-btrfs@vger.kernel.org>; Fri, 12 May 2017 04:16:35 -0700 (PDT)
Subject: Re: Qgroup reserved space like in ZFS?
To: Robert Mader <robert.mader@liqd.de>, linux-btrfs@vger.kernel.org
References: <cf95a201-a8c5-ad94-3a98-81e55bf63a6c@liqd.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <57de279f-fd62-dc4c-efd4-ac1d85f1bdd6@gmail.com>
Date: Fri, 12 May 2017 07:16:31 -0400
MIME-Version: 1.0
In-Reply-To: <cf95a201-a8c5-ad94-3a98-81e55bf63a6c@liqd.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-11 12:17, Robert Mader wrote:
> Hello everyone,
>
> I just wanted to ask a short question as I couldn't find a clear answer
> anywhere on the net, yet:
>
> Is it currently possible to reserve space for a BTRFS subvolume?
Currently, there is no way to do this directly right now.  However, you 
_can_ do this with regular quotas as implemented by qgroups, you just 
set each subvolume to have a quota equal to the size of the volume minus 
the amount of space you want reserved to other subvolumes.  While 
inconvenient, this will produce behavior functionally identical to 
setting reserved space on data sets in ZFS without setting quotas, as 
long as you don't add or remove subvolumes.
>
>
> Following example: I have two subvolumes, one for root and one for home
>
> I'd like to reserve 2GB of space for my root volume so even if my home
> volume fills up, it can never starve my root subvolume.
> But I don't want to set a fixed limit on my home partition, I want both
> subvolumes to be able to grow and shrink dynamically.
>
> I use that functionality a lot on ZFS-based systems like FreeNAS. In the
> the web-interface of FreeNAS one can easily configure things like that.
>
>
> If I get it right, qgroups actually already create things like a global
> reserve. Therefor the functionality seems to be there. Is there a way to
> use it, just like the limit functionality? Or is it planed?
I'm not certain about this myself, but you may be thinking of the 
GlobalReserve area in the metadata, which actually has nothing to do 
with how qgroups work, and is instead used to allow things to keep 
working to a limited degree when the filesystem is full.
