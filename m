From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: very poor read / write performance compared to other FS's?
Date: Fri, 13 May 2011 10:07:18 +0800
Message-ID: <BANLkTi=EJP5HP9TzmpZ82evHWJR7Ygygrg@mail.gmail.com>
References: <BANLkTinRa9TdVOAaMt9_gcR2xDhbDWVJcA@mail.gmail.com>
	<20110512153901.GA19041@dhcp231-156.rdu.redhat.com>
	<BANLkTikq5eDYL0dPnB-iMPCuMfmCAqWMAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Marek Fstump <marekfstump@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikq5eDYL0dPnB-iMPCuMfmCAqWMAw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 13 May 2011 07:15, Marek Fstump <marekfstump@gmail.com> wrote:
> On Thu, May 12, 2011 at 4:39 PM, Josef Bacik <josef@redhat.com> wrote=
:
>> On Wed, May 11, 2011 at 11:33:35PM +0100, Marek Fstump wrote:
>>> Hi
>>>
>>> I am very interested in using BTRFS for my solution but in basic te=
sts
>>> it seems to be very poor on read and write performance. =A0I am
>>> surprised by this so suspect that maybe I am doing something
>>> incorrectly or that there are updates I should be using, but I am n=
ot
>>> sure how I update BTRFS on SLES11
>>>
>>> Summary:
>>> RESULTS on link below
>>> SLES11 SP1
>>> Compared Sequential read/write performance against XFS and OCFS2
>>> Backend storage =96 FusionIO SLC SSD =3D circa 750MBsec
>>>
>>> Tests =A0set as follows:
>>> Filesystem contains 30 x 4GB files (made of random data)
>>> Read tests will read from 1 to 30 files concurrently
>>> Write tests will write 1 to 30 concurrent NEW files (simple 000=92s=
)
>>> dd -direct flag used on writes
>>>
>>> All defaults used for mounting etc.
>>>
>>> Results shown in attachment.
>>>
>>> BTRFS looks an excellent FS and perfect for my application and I am
>>> hoping that there are some factors that I am missing
>>> and would appreciate any advice / help
>>>
>>
>> Yeah our O_DIRECT performance is less than stellar, I just did a bun=
ch of work
>> to try and help us get a little better performance. =A0Would you min=
d pulling
>> down linus's git tree and testing on that and seeing if you get bett=
er
>> performance? =A0Thanks,
>>
>> Josef
>>
>
> Hi Josef
>
> Forgive me as i am a 'storage guy' - so when you say pull down linus'=
s
> git tree and test.... do you mean grab the latest kernel? =A0i know v=
ery
> stupid question, but just want to make sure i get it right... if so,
> then yes i will and i will add some more storage power also to see if
> it scales.

=46or  SLES 11, the kernel RPMs here may be your best shot:

http://download.opensuse.org/repositories/Kernel:/stable/standard/x86_6=
4/

(eg kernel-default-2.6.38.6-1.1.x86_64.rpm)

You'll probably have to download dependent RPMs from there too.

Thanks,
  Daniel
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
