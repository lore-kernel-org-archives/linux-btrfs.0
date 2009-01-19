From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: [Patch] Btrfs: use BTRFS_VOL_NAME_MAX for struct
	btrfs_ioctl_vol_args
Date: Mon, 19 Jan 2009 21:12:24 +0800
Message-ID: <20090119131224.GC7424@hack.private>
References: <20090119125732.GA7424@hack.private> <20090119130337.GA25475@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
	linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@osdl.org>
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090119130337.GA25475@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 19, 2009 at 08:03:37AM -0500, Josef Bacik wrote:
>On Mon, Jan 19, 2009 at 08:57:32PM +0800, Am=C3=A9rico Wang wrote:
>>=20
>> I found userspace tool, btrfsctl, uses BTRFS_VOL_NAME_MAX, and
>> it also looks that this one is more proper.
>>=20
>> Kill BTRFS_PATH_NAME_MAX since no one will use it.
>>=20
>
>Nope, BTRFS_PATH_NAME_MAX is specifically used for the ioctl stuff, ma=
kes the
>arguments 4k aligned, this patch is incorrect.  Thanks,

Ok, then what is BTRFS_VOL_NAME_MAX? :)


--=20
"Against stupidity, the gods themselves, contend in vain."

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
