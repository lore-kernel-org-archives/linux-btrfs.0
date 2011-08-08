From: Andrew Lutomirski <luto@mit.edu>
Subject: Re: space cache generation (...) does not match inode (...)
Date: Mon, 8 Aug 2011 08:17:23 -0400
Message-ID: <CAObL_7Hy-WedybTXz+4Sja6XAM3rc5wx1+hf2wa35UggBuffsw@mail.gmail.com>
References: <CAObL_7Hc0AGOB8Jk-o_hseiqxEfDWFLSnMkhLLiu00GVbr729Q@mail.gmail.com>
 <4E3FD332.5020002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E3FD332.5020002@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 8, 2011 at 8:14 AM, Josef Bacik <josef@redhat.com> wrote:
> On 08/06/2011 10:16 PM, Andrew Lutomirski wrote:
>> I've always gotten space cache generation warnings, but some time
>> after 3.0 they started going nuts. =A0I get:
>>
>> space cache generation (14667727114112179905) does not match inode (=
154185)
>>
>> and other similar messages (with a huge number and a smaller number)
>> at rates higher than one message per ms. =A0They don't happen
>> constantly, but they come in bursts big enough to fill my log buffer=
=2E
>>
>
> Yeah sorry that's going to happen when you first switch to 3.0. =A0We
> switched the space cache stuff over to using the normal checksumming
> code so all old space cache is going to look invalid. =A0This is noth=
ing
> to worry about, it will just end up discarded and re-generated. =A0Th=
anks,

Can you put in a rate limit and make the message less alarming?
There's enough log spam from it that I can't see anything else in my
log.

--Andy

>
> Josef
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
