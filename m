From: =?iso-8859-1?Q?Bryan_=D8stergaard?= <bryan.ostergaard@gmail.com>
Subject: Re: A rescue tool for btrfs
Date: Mon, 20 Dec 2010 13:18:21 +0100
Message-ID: <E160A2D4-258B-41FC-8035-7D5637A6FB03@gmail.com>
References: <20101217001849.1b5f4c28@simplux>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Michael Niederle <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101217001849.1b5f4c28@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

On 17/12/2010, at 00.18, Michael Niederle wrote:

> Hi!
>=20
> Last week I crashed a btrfs file system. I didn't lose a lot of data =
because I
> had current backups of most data and a full backup from a month ago.
>=20
> But I thought it would be a nice idea to have a rescue tool! Currentl=
y I have a
> first release of this tool (surely buggy and runnning on little endia=
n
> architectures only).
>=20
Thank you for writing this tool. It was able to save some 80% of all da=
ta from a=20
very broken btrfs filesystem. I could mount the filesystem but it would=
 hang after=20
just a few accesses with thousands of parent transid verify failed mess=
ages and
btrfsck just exited immediately with some huge negative number as the o=
nly=20
indication of what was wrong. Using the btrfsck -s $number option also =
didn't=20
help but your tool seemed to do the job just fine.

I still have the broken filesystem as I'm interested to see what Chris =
Masons new=20
btrfsck code can do with it so if anybody is interested in further debu=
gging I can=20
probably help with that.

Regards,
Bryan =D8stergaard

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
