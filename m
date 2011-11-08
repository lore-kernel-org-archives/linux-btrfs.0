From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: smatch stuff: potential NULL dereference in btrfs_rm_device()
Date: Tue, 8 Nov 2011 17:16:00 +0200
Message-ID: <20111108151600.GA1339@zambezi.lan>
References: <20111108145944.GA30841@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111108145944.GA30841@elgon.mountain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2011 at 05:59:45PM +0300, Dan Carpenter wrote:
> Hi Yan,
> 
> Smatch complains about this code from 2008.
> 
> fs/btrfs/volumes.c +1417 btrfs_rm_device(157)
> 	error: we previously assumed 'fs_devices' could be null (see line 1412)
> 
>   1412                  while (fs_devices) {
>                                ^^^^^^^^^^
> checked here.
> 
>   1413                          if (fs_devices->seed == cur_devices)
>   1414                                  break;
>   1415                          fs_devices = fs_devices->seed;
>   1416                  }
>   1417                  fs_devices->seed = cur_devices->seed;
>                         ^^^^^^^^^^^^
> dereferenced here.
> 
> If we don't hit the break statement, then at the end of the loop we'd
> oops.

I don't think Zheng works for Oracle (and on Btrfs) any more.  I'll look
into it.

Thanks,

		Ilya
