From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: grub-0.97: btrfs multidevice  support [PATCH]
Date: Fri, 25 Sep 2009 07:16:09 -0700
Message-ID: <4ABCD0A9.4040408@redhat.com>
References: <4ABBC1F5.70808@redhat.com> <20090924202146.GA16412@thorin> <20090924223810.GA2638@brong.net> <20090925140951.GA6318@thorin>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Bron Gondwana <brong@fastmail.fm>,
	The development of GRUB 2 <grub-devel@gnu.org>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Robert Millan <rmh@aybabtu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090925140951.GA6318@thorin>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/25/2009 07:09 AM, Robert Millan wrote:
> On Fri, Sep 25, 2009 at 08:38:10AM +1000, Bron Gondwana wrote:
>> On Thu, Sep 24, 2009 at 10:21:46PM +0200, Robert Millan wrote:
>>>
>>> Hi Edward,
>>>
>>> I'm sorry but GRUB Legacy is not maintained.  At least not by us;  we've
>>> deprecated it in favour of GRUB 2.
>>>
>>> It is also being abandoned by distributors, so I wouldn't recommend that you
>>> put any effort in developing for it.
>>
>> You've been spouting this line for years, and yet my Ubuntu 10.4 machine
>> uses, guess what, GRUB 1.  Mainly because you deprecated GRUB Legacy[tm]
>> well before GRUB 2 was usable.
>>
>> (you in the generic sense of the GRUB project here)
>>
>> Edward - please do continue to develop patches for GRUB 1 (the one that
>> still actually works plenty well enough for lots of people) and ignore the
>> naysayers who are happy to throw out backwards compatibility.
>>
>> Sometimes you have to maintain crappy code because people out there depend
>> on it.  And we thank those who step up and do it rather than throw their
>> hands up and pretend it doesn't need doing!
>
> I'm not telling anyone what should or shouldn't work with.  But if you want to
> work on a branch we consider deprecated, please do it elsewhere.  Discussion
> regarding GRUB Legacy is off-topic in this list.
>
> Thanks
>

That would be rather unusual - we certainly discuss ext2 and ancient file 
systems in our ext development lists.

A lot of distros (and their users) still use grub, just like a lot of users 
still use ext2.

Working on grub2 is great, but until it meets the needs and wins over the 
distros, you will unfortunately still need to put up with contributions to the 
old code base.

Have you looked at what it would take you (or others) to move Edward's patches 
into grub2?

Regards,

Ric

