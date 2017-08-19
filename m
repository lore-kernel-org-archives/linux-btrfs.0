Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31-i6.italiaonline.it ([212.48.14.165]:56931 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751038AbdHSNIf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 19 Aug 2017 09:08:35 -0400
Reply-To: kreijack@inwind.it
Subject: Re: qcow2 images make scrub believe the filesystem is corrupted.
To: Josef Bacik <josef@toxicpanda.com>
Cc: Paulo Dias <paulo.miguel.dias@gmail.com>, linux-btrfs@vger.kernel.org
References: <CADJPUQ9awnz30XzGZLGQAUhAqeH5ek6stDN5N5JTzc3dGtdiug@mail.gmail.com>
 <20170817233916.GA25527@destiny>
 <ceb36a9a-b73f-96c1-cb58-24f149b24001@libero.it>
 <20170818174356.GA1526@destiny>
 <5165a965-ef9d-9db3-d618-f9bef6bfbe5e@inwind.it>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <09c963e3-7b70-e817-d634-3fa54d571f91@inwind.it>
Date: Sat, 19 Aug 2017 15:08:32 +0200
MIME-Version: 1.0
In-Reply-To: <5165a965-ef9d-9db3-d618-f9bef6bfbe5e@inwind.it>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/19/2017 12:19 AM, Goffredo Baroncelli wrote:
>> We have no way of making sure nobody
>> touches the page while we're writing it out, so after we calculate the checksum
>> any changes to the page are going to cause a checksum mismatch.  O_DIRECT are
>> user space pages, there's nothing we can do to stop user space from doing stupid
>> things.
> I understand the technical difficulties; 

I looked how ZFS deal with this problem. According of this thread [1] it seems that currently ZFS (on linux) doesn't support O_DIRECT. In this thread it is mentioned that one of the problem is the coherency between data and checksum.

I think that it is better to not support O_DIRECT for cow files than having mismatched checksum..

BR
G.Baroncelli

[1] https://github.com/zfsonlinux/zfs/issues/224


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
