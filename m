Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60702 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753226AbeBTQlb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Feb 2018 11:41:31 -0500
Subject: Re: btrfs_clone_files and bind mounts
To: Hristo Venev <hristo@venev.name>, linux-btrfs@vger.kernel.org
References: <1519141810.8586.4.camel@venev.name>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2ce8eab1-8951-a1c7-d4fa-5f4f3201923d@suse.com>
Date: Tue, 20 Feb 2018 18:41:28 +0200
MIME-Version: 1.0
In-Reply-To: <1519141810.8586.4.camel@venev.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20.02.2018 17:50, Hristo Venev wrote:
> What is the problem with cloning files between different (vfs)mounts of
> the same filesystem?
> 

The "problem" is not really a problem, but rather a well-imposed
restriction:

>From  http://man7.org/linux/man-pages/man2/ioctl_ficlonerange.2.html

"Both files must reside within the same filesystem."

And as a matter of fact this is enforced in the generic
vfs_clone_file_range. Of course if we were to do this across filesystem
then we'd have all the problems associated with not being able to ensure
atomicity of operations.
