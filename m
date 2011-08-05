From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH] snapshot, defragment and raid test cases for btrfs
Date: Fri, 5 Aug 2011 17:42:24 -0400
Message-ID: <CAGpXXZJRiLX4ykUuneK7jaQrXjuP_STVxvG-MROnM02TLuCDjA@mail.gmail.com>
References: <4E3BA2F7.4080500@oracle.com> <CAOQ4uxjVPJmXAFDmWM4K6n5b36PutV1JOkRMzLqeipZkY8AhAg@mail.gmail.com>
 <CAGpXXZKUmrWoj1F3PjwE2Yq0oYx2_0JLX3x_kxRBBA-Uk4h4OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Anand Jain <Anand.Jain@oracle.com>, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com,
	Chris Mason <chris.mason@oracle.com>,
	Aditya Dani <aditya.dani@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAGpXXZKUmrWoj1F3PjwE2Yq0oYx2_0JLX3x_kxRBBA-Uk4h4OQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 5, 2011 at 11:40 AM, Greg Freemyer <greg.freemyer@gmail.com=
> wrote:
> On Fri, Aug 5, 2011 at 9:53 AM, Amir Goldstein <amir73il@gmail.com> w=
rote:
>> Hi Anand,
>>
>> Can you please post the patch in the body of the message so we can
>> comment on it inline.
>>
>> Aditya is also working on a btrfs snapshots xfstest (currently named
>> 257) as part of
>> his Google summer of code project.
>>
>> It would be great if you guys can cooperate your efforts.
>>
>> BTW, while running Aditya's test, Greg has stumbled upon a btrfs OOP=
S.
>> Greg can provide more details about it.
>>
>> Cheers,
>> Amir.
>>
>> On Fri, Aug 5, 2011 at 10:59 AM, Anand Jain <Anand.Jain@oracle.com> =
wrote:
>>>
>>> Hi,
>>>
>>> =A0Attached is the patch for the xfstests, which adds snapshot,
>>> =A0defragment and volume management test cases for the btrfs
>>> =A0(257, 258 and 259 respectively).
>>>
>>> =A0This introduces a new user variable 'DISK_POOL' which should
>>> =A0be set to disks for the raid tests.
>>>
>>> =A0An example of usage of these tests is as below.
>>> ------------
>>> [root@localhost xfstests]# cat local.config
>>> TEST_DEV=3D"/dev/sdd"
>>> TEST_DIR=3D/btrfs
>>> SCRATCH_DEV=3D"/dev/sde"
>>> SCRATCH_MNT=3D/btrfs1
>>> DISK_POOL=3D"/dev/sdf /dev/sdg"
>>> [root@localhost xfstests]#
>>>
>>> [root@localhost xfstests]# ./check 257 258 259
>>> FSTYP -- btrfs
>>> PLATFORM -- Linux/i686 localhost 3.0.0-rc6+
>>> MKFS_OPTIONS -- /dev/sde
>>> MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:nfs_t:s0 /dev/sde /=
btrfs1
>>>
>>> 257 8s
>>> 258 3s
>>> 259 33s
>>> Ran: 257 258 259
>>> Passed all 3 tests
>>> ----------------
>>>
>>> =A0Thank you.
>>>
>>> Anand
>>>
>
> Anand,
>
> I've only reproduced the oops in 2.6.39 and older using openSUSE 11.4=
 userspace.
>
> I have not tried with 3.0 or newer nor with newer userspace, so it ma=
y
> or may not have been fixed.
>
> It happened with a openSUSE kernel, so I put it in their bugzilla.
>
> https://bugzilla.novell.com/show_bug.cgi?id=3D705039

I just tested with kernel 3.0 and the oops is gone.

I closed that bugzilla as resolved.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
