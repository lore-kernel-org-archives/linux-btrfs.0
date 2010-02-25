From: Andrew Lutomirski <luto@mit.edu>
Subject: Re: [2.6.33 regression] btrfs mount causes memory corruption
Date: Thu, 25 Feb 2010 15:29:34 -0500
Message-ID: <cb0375e11002251229q2a6989c5n64d739dec4f8de44@mail.gmail.com>
References: <cb0375e11002251201v7969b891n687f928e2402f7c9@mail.gmail.com>
	<20100225202358.GC10960@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100225202358.GC10960@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 25, 2010 at 3:23 PM, Josef Bacik <josef@redhat.com> wrote:
> On Thu, Feb 25, 2010 at 03:01:08PM -0500, Andrew Lutomirski wrote:
>> Mounting btrfs corrupts memory and causes nasty crashes within a few
>> seconds. =A0This seems to happen even if the mount fails (note the
>> unrecognized mount option). =A0This is a regression from 2.6.32, and
>> I've attached an example.
>>
>
> And it only happens when you mount a btrfs fs? =A0Can you show me a t=
race of when
> you mount a btrfs fs with valid mount options? =A0I'd like to see if =
we're not
> cleaning up something properly or what. =A0Thanks,

Seems OK.  Or maybe I just got lucky, but it's crashed every time I
tried to mount with 'acl' before.

I even went through a couple iterations of trying to mount with
'xattr' and 'user_xattr', both of which failed.

--Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
