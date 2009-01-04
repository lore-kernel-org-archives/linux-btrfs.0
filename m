From: "Miguel Figueiredo Mascarenhas Sousa Filipe"
	<miguel.filipe@gmail.com>
Subject: Re: btrfs: Problem with multi device mounting
Date: Sun, 4 Jan 2009 15:17:42 +0000
Message-ID: <f058a9c30901040717y5abb1eb4lc732743f0cbad314@mail.gmail.com>
References: <b82a89170812070935p36a2285ft30d475198206f89f@mail.gmail.com>
	 <3d0408630812071701w4be6bdc6h806f50600bcd0cf6@mail.gmail.com>
	 <20081208034401.GA8828@niraj-laptop>
	 <200901041338.08894.trapni@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Christian Parpart" <trapni@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200901041338.08894.trapni@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 4, 2009 at 12:38 PM, Christian Parpart <trapni@gentoo.org> wrote:
> On Monday 08 December 2008 04:44:01 Niraj Kumar wrote:
>> On Mon, Dec 08, 2008 at 09:01:11AM +0800, Yan Zheng wrote:
>> > 2008/12/8 Niraj kumar <niraj17@gmail.com>:
>> >
>> > Please execute 'btrfsctl -a' before mount.
>
> How does this play nice with root partitions that are planned to be btrfs?
>

initrd ?

basically is the same problem that root partitions on md
raid0,1,10,5,6 face... device discovery and assembly of block device
in case of md, or assembly of filesystem kernel data/structs in case
of btrfs.


> Regards,
> Christian.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Miguel Sousa Filipe
