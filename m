From: Ben Chociej <bchociej@gmail.com>
Subject: Re: [PATCH 2/2] Btrfs-progs: Add hot data support in mkfs
Date: Fri, 13 Aug 2010 09:12:41 -0500
Message-ID: <AANLkTikA_S5+vv=EM8hiakG0mYfanuOpRsicpr3_TZgQ@mail.gmail.com>
References: <1281652177-23562-1-git-send-email-bchociej@gmail.com>
 <1281652177-23562-3-git-send-email-bchociej@gmail.com> <20100813131422.GA615@centrinvest.ru>
 <20100813140810.GB24029@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	bchociej@gmail.com, chris.mason@oracle.com,
	linux-fsdevel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
	mrlupfer@us.
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100813140810.GB24029@mother.pipebreaker.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 13, 2010 at 9:08 AM, Tomasz Torcz <tomek@pipebreaker.pl> wr=
ote:
> On Fri, Aug 13, 2010 at 05:14:22PM +0400, Andrey Panin wrote:
>> On 224, 08 12, 2010 at 05:29:37PM -0500, bchociej@gmail.com wrote:
>> > From: Ben Chociej <bchociej@gmail.com>
>> >
>> > Modified mkfs.btrfs to add hot data relocation option (-h) which
>> > preallocates BTRFS_BLOCK_GROUP_DATA_SSD and
>> > BTRFS_BLOCK_GROUP_METADATA_SSD at mkfs time for future use by hot =
data
>> > relocation code. =A0Also added a userspace function to detect whet=
her a
>> > block device is an SSD by reading the sysfs block queue rotational=
 flag.
>>
>> IMHO this policy is too inflexible. What if I have large array of sl=
ow SATA
>> disks and some fast SAS ones ?
>
> =A0I'm hoping that this is just first cut, and future versions will h=
ave options.
> For now, it is totally unusable without a way of using mirrored SSD f=
or
> hot data.
> =A0Ideally, hot storage devices should be online selectable and chang=
eable.
>
> --
> Tomasz Torcz =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 72->| =A0 80->|
> xmpp: zdzichubg@chrome.pl =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A072->| =A0 80->|
>
>

This is very much just a first cut. Our goal here was to get a lot of
the legwork and experimental coding out of the way to enable to Btrfs
to *fully* tackle heterogeneous storage in the future.

BC
