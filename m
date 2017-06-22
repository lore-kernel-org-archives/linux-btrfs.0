Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:37633 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750854AbdFVLbk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Jun 2017 07:31:40 -0400
Received: by mail-it0-f46.google.com with SMTP id m47so19038312iti.0
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Jun 2017 04:31:40 -0700 (PDT)
Subject: Re: Stability status of btrfs-convert...
To: Shyam Prasad N <nspmangalore@gmail.com>, linux-btrfs@vger.kernel.org
References: <CANT5p=p_EXUL=zWPqym8BygcQZpFgJk0kK9+zKdE1zgMkJccGQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <c32c656c-fb94-e44c-fcf6-0f0c352c75b1@gmail.com>
Date: Thu, 22 Jun 2017 07:31:36 -0400
MIME-Version: 1.0
In-Reply-To: <CANT5p=p_EXUL=zWPqym8BygcQZpFgJk0kK9+zKdE1zgMkJccGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-06-22 05:37, Shyam Prasad N wrote:
> Hi,
> 
> I'm planning to use the btrfs-convert tool to convert production data
> in ext4 filesystem into btrfs.
> What is the stability status of this feature?
> 
> As per the below link, this tool is not in frequent use in latest linux kernels.
> https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3
> 
> Can I know the reason why? Is it because most existing ext4
> filesystems are already converted?
> Is this tool supported, at least? Can I use this tool as a part of
> software upgrade to change the data filesystem to btrfs?
Yes, it's supported, but unless you need the ability to switch back as 
quickly as possible, you are almost certainly better off restoring data 
from a fresh backup onto a new BTRFS filesystem than you are converting 
it in-place.  I have heard of no currently extant bugs in btrfs-convert, 
but they usually don't show up immediately, and even if there are no 
bugs, you still end up with a very sub-optimal on-device layout which 
isn't even completely fixed by deleting the ext4 metadata and 
re-balancing, and that will in turn hurt performance somewhat.  At a 
minimum, I would suggest running e4defrag over the whole filesystem 
prior to converting, as that will at least reduce the degree of 
fragmentation you start with.
