Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31670 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3K2Br5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 20:47:57 -0500
Message-ID: <5297F475.9070009@oracle.com>
Date: Fri, 29 Nov 2013 09:57:09 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: Wang Shilong <wangshilong1991@gmail.com>,
        "dsterba@suse.cz Sterba" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org FILE SYSTEM list:BTRFS"
	<linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: calculate disk space that a subvol could
 free
References: <1380300329-9123-1-git-send-email-anand.jain@oracle.com> <1380468336-5170-1-git-send-email-anand.jain@oracle.com> <20131001133919.GE18291@twin.jikos.cz> <C56AFBE2-55D0-4E05-9903-5DD61E3C3D1A@gmail.com> <525220DC.2030403@oracle.com> <20131008164951.GC12986@twin.jikos.cz> <237D022A-BBC2-412C-9E41-45EB4B299660@gmail.com> <5256206C.3080306@oracle.com> <52562019.4090508@cn.fujitsu.com> <CAOcd+r2OJAf1MfHeB46K7bbhPTwWiM6SKCpRVojFbY18SBWEKg@mail.gmail.com> <5297EF3F.4030400@cn.fujitsu.com>
In-Reply-To: <5297EF3F.4030400@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> If so, i don't think this should be implemented in user space, Btrfs quota
> implement such function in kernel space, but it also face a problem that
> deleting a subvolume will break space accounting(because subvolume deletion
> won't iterate the whole fs tree).

Hi Alex, Wang.

  Thanks for comments, as Wang suggested before,  I am working on
  the qgroups to handle our user space requisites here. I will be
  sending out review patch soon. pls stay tuned.

Thanks, Anand

