From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [RFC] Subvolume Quota on-disk structures and configuration
Date: Mon, 21 Nov 2011 13:29:38 -0500
Message-ID: <4ECA9892.9070801@cfl.rr.com>
References: <4E19611D.2090007@gmx.net> <4ECA7721.3040607@cfl.rr.com> <4ECA8847.2080905@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ECA8847.2080905@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/21/2011 12:20 PM, Arne Jansen wrote:
> On 11/21/2011 05:06 PM, Phillip Susi wrote:
>> On 7/10/2011 4:21 AM, Arne Jansen wrote:
>>> btrfs qgroup limit [--exclusive]<size>|none<qgroupid>  <path>
>>>
>>>
>>> btrfs qgroup limit 10g /usr
>>>
>>> That should be simple enough for the common use case.
>>
>> Wouldn't that make the syntax above actually be:
>>
>> btrfs qgroup limit [--exclusive]<size|none>  [qgroupid]<path>
>
> You don't mean to actually changing the syntax, but adding a better
> explanation or a more precise usage?

What I mean is that your syntax listed <groupid> in angle brackets, 
indicating that it is a required argument, but your description seems to 
indicate that it is optional, so it should be in square brackets.  Also 
the size bit I assume was meant to be a required parameter that should 
be either a number or the word none, so the angle brackets should 
enclose the |none part too.

>> I also have a question about the interactions with groups of groups. Say
>> I have 4 subvolumes: 1, 2, 3, and Z.  I group the first 3 volumes and
>> set a limit on them.  Now if all 3 volumes share a chunk of space, that
>> space should only count towards the group once, rather than 3 times.
>
> It's just what groups are made for. In your scenario the chunk of space
> would count only once. Some hopefully better explanation can be found at

Ohh, so the group is a union of the chunks in the members, not a sum? 
So if you set an exclusive limit on the group, that would count 
everything shared between 1, 2, 3 once, and not count any shared with Z? 
  In other words, --exclusive excludes space shared with things outside 
the group, not within it?

> http://sensille.com/qgroups.pdf
>
> Have you already played with the patchset?

Not yet; I just found it today from the new thread on the subject, and 
look forward to playing with it tonight.  I was wondering what revision 
the patches are based on, and are they in a public git repo?
