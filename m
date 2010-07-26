From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: File cloning across subvolumes with BTRFS_IOC_CLONE ioctl
Date: Mon, 26 Jul 2010 08:55:09 -0400
Message-ID: <AANLkTi=jfxhiX71Hbug2REhRRXyJ8MDSxo=4LuFmtaOD@mail.gmail.com>
References: <20100720053934.GA14402@epicurus>
	<AANLkTil_bqyOwBIlkdZGyn1HAVKBMuEu4cem2UAhei3A@mail.gmail.com>
	<20100721153224.GY3133@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	=?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>,
	redneb <redneb@gmx.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100721153224.GY3133@think>
List-ID: <linux-btrfs.vger.kernel.org>

After pulling the new changes, I tried to do the cp --reflink=3Dalways
and still get files with no data in it.
cp --reflink=3Dalways on different subvolume: http://pastebin.com/zutMP=
e1h
ls -lisa on source: http://pastebin.com/8BU2Xyr5
ls -lisa on destination after trying to copy: http://pastebin.com/EPV70=
cD3

However, copying on the same subvolume now works perfectly, so I guess
this is fixed.

On Wed, Jul 21, 2010 at 11:32 AM, Chris Mason <chris.mason@oracle.com> =
wrote:
> On Wed, Jul 21, 2010 at 11:11:13AM -0400, J=E9r=F4me Poulin wrote:
>> I've got the same problem, and that post clearly seems to say it is =
possible.
>> cp --reflink=3Dalways source subvolume1/ =A0 gives me:
>> cp: failed to clone `xxxx': Invalid cross-device link
>>
>> Even on the same subvolume I get 10% of the files telling me the sam=
e.
>>
>> btrfs-bcp copy the files in its integrity.
>
> Ok, this is a bug in the ioctl. =A0I'll fix it up.
>
> -chris
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
