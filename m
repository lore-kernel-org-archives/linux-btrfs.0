From: Avi Kivity <avi@redhat.com>
Subject: Re: oops in btrfs_reserve_extent (v0.16)
Date: Mon, 29 Sep 2008 11:13:32 +0300
Message-ID: <48E08E2C.8080903@redhat.com>
References: <48DFEC18.6070303@redhat.com> <20080929000855.GA26676@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080929000855.GA26676@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:
> Could you try with the unstable git tree?  I just rewrote a bunch of this stuff
> and like to know if the same issue is present there.  I wouldn't recommend using
> unstable for your home directory yet tho, that code still may eat children.
> Thanks,
>   

Will try that on a virtual machine -- unfortunately I am too far 
bandwidth wise from an F9 installer.

Meanwhile I rsync'ed my /home without online resizing, using v0.16.  
Filesystem and myself both happy.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

