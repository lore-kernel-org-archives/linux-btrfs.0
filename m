From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] snapshot, defragment and raid test cases for btrfs
Date: Fri, 5 Aug 2011 16:53:01 +0300
Message-ID: <CAOQ4uxjVPJmXAFDmWM4K6n5b36PutV1JOkRMzLqeipZkY8AhAg@mail.gmail.com>
References: <4E3BA2F7.4080500@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com, Chris Mason <chris.mason@oracle.com>,
	Aditya Dani <aditya.dani@gmail.com>,
	Greg Freemyer <greg.freemyer@gmail.com>
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4E3BA2F7.4080500@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,

Can you please post the patch in the body of the message so we can
comment on it inline.

Aditya is also working on a btrfs snapshots xfstest (currently named
257) as part of
his Google summer of code project.

It would be great if you guys can cooperate your efforts.

BTW, while running Aditya's test, Greg has stumbled upon a btrfs OOPS.
Greg can provide more details about it.

Cheers,
Amir.

On Fri, Aug 5, 2011 at 10:59 AM, Anand Jain <Anand.Jain@oracle.com> wro=
te:
>
> Hi,
>
> =A0Attached is the patch for the xfstests, which adds snapshot,
> =A0defragment and volume management test cases for the btrfs
> =A0(257, 258 and 259 respectively).
>
> =A0This introduces a new user variable 'DISK_POOL' which should
> =A0be set to disks for the raid tests.
>
> =A0An example of usage of these tests is as below.
> ------------
> [root@localhost xfstests]# cat local.config
> TEST_DEV=3D"/dev/sdd"
> TEST_DIR=3D/btrfs
> SCRATCH_DEV=3D"/dev/sde"
> SCRATCH_MNT=3D/btrfs1
> DISK_POOL=3D"/dev/sdf /dev/sdg"
> [root@localhost xfstests]#
>
> [root@localhost xfstests]# ./check 257 258 259
> FSTYP -- btrfs
> PLATFORM -- Linux/i686 localhost 3.0.0-rc6+
> MKFS_OPTIONS -- /dev/sde
> MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:nfs_t:s0 /dev/sde /bt=
rfs1
>
> 257 8s
> 258 3s
> 259 33s
> Ran: 257 258 259
> Passed all 3 tests
> ----------------
>
> =A0Thank you.
>
> Anand
>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
