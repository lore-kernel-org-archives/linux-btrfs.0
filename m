From: Diego Calleja <diegocg@gmail.com>
Subject: Re: 2.6.36-rc1 btrfs still unstable
Date: Tue, 17 Aug 2010 00:25:47 +0200
Message-ID: <201008170025.47510.diegocg@gmail.com>
References: <1281948382.1888.7.camel@chotu> <7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5BC@mail.corp.imt-systems.com> <m3iq3a4l46.fsf@pullcord.laptop.org>
Reply-To: diegocg@gmail.com
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: "Morten P.D. Stevens" <mstevens@imt-systems.com>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3iq3a4l46.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Lunes, 16 de Agosto de 2010 17:45:29 Chris Ball escribi=F3:
>    Note that Btrfs does not yet have a fsck tool that can fix errors.
>    While Btrfs is stable on a stable machine, it is currently possibl=
e
>    to corrupt a filesystem irrecoverably if your machine crashes or
>    loses power.  This will be fixed when the fsck tool is ready.

But doesn't this happen only with cheap disks that don't honour barrier=
s
correctly?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
