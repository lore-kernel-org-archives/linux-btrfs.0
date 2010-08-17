From: =?UTF-8?Q?Rodrigo_E=2E_De_Le=C3=B3n_Plicet?= <rdeleonp@gmail.com>
Subject: Re: 2.6.36-rc1 btrfs still unstable
Date: Tue, 17 Aug 2010 11:25:03 -0500
Message-ID: <AANLkTimb3PFtEWv8oKdVLrK3YviAaOO2J3hVkiPsyCDM@mail.gmail.com>
References: <1281948382.1888.7.camel@chotu> <20100816121658.GT3315@think>
 <7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5BC@mail.corp.imt-systems.com> <m3iq3a4l46.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Morten P.D. Stevens" <mstevens@imt-systems.com>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3iq3a4l46.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 16, 2010 at 10:45 AM, Chris Ball <cjb@laptop.org> wrote:
> Note that Btrfs does not yet have a fsck tool that can fix errors.
> =C2=A0 While Btrfs is stable on a stable machine, it is currently pos=
sible
> =C2=A0 to corrupt a filesystem irrecoverably if your machine crashes =
or
> =C2=A0 loses power. =C2=A0This will be fixed when the fsck tool is re=
ady.

Um, is this related to disks lying about actually writing to spinning
rust, or can this happen on disks that do so properly?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
