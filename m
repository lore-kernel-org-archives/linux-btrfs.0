From: Sriram Ramkrishna <sriram.ramkrishna@gmail.com>
Subject: Re: extended acls..
Date: Tue, 19 May 2009 11:16:54 -0700
Message-ID: <42ab06770905191116v18e42ce7w3ab7c35e131d6eef@mail.gmail.com>
References: <42ab06770905190950x5077edb0s3c55bd1c39ebeebe@mail.gmail.com>
	<20090519180608.GC7472@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090519180608.GC7472@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

Thanks, I will take it to linux-fsdevel.

sri

On Tue, May 19, 2009 at 11:06 AM, Josef Bacik <josef@redhat.com> wrote:
> On Tue, May 19, 2009 at 09:50:42AM -0700, Sriram Ramkrishna wrote:
>> Howdy,
>>
>> I'm curious if there is any plans to add extended acls ala AFS? =C2=A0=
The
>> reason I ask is that it seems in Linux we don't seem have moved off =
of
>> POSIX style acls and I think there is definitely at least from my
>> perspective that having a richer set of acl would be needed. =C2=A0F=
or
>> instance, we would need acls to deal with controlled countries if we
>> are sharing data with them etc. =C2=A0It is a big shame that there i=
s no
>> RFC for extended ACLs.
>>
>> Also, I would like to help out with development, I'm a newbie as far
>> as kernel level hacking goes. =C2=A0If there is a place I can go tha=
t I can
>> start off small that would be lovely.
>>
>
> Extending ACLs beyond POSIX ACLs is a more generic topic that should =
probably be
> discussed elsewhere, perhaps linux-fsdevel. =C2=A0Its not going to do=
 much good to
> implement yet another extended ACL implementation in BTRFS if no othe=
r Linux fs
> has the ability to use the same feature, so figuring out the details =
of
> extending ACLs should be done before doing them in btrfs. =C2=A0Thank=
s,
>
> Josef
>



--=20
-- Sriram Ramkrishna (sriram.ramkrishna_@@_@.gmail.com (remove _@@_)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
