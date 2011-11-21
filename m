From: Arne Jansen <sensille@gmx.net>
Subject: Re: [RFC] Subvolume Quota on-disk structures and configuration
Date: Mon, 21 Nov 2011 21:15:30 +0100
Message-ID: <4ECAB162.1030101@gmx.net>
References: <4E19611D.2090007@gmx.net> <4ECA7721.3040607@cfl.rr.com> <4ECA8847.2080905@gmx.net> <4ECA9892.9070801@cfl.rr.com> <4ECA9DBF.40104@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ECA9DBF.40104@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

[I accidentally failed to include the list in the previous reply]

On 11/21/2011 07:51 PM, Arne Jansen wrote:
> On 11/21/2011 07:29 PM, Phillip Susi wrote:
>> On 11/21/2011 12:20 PM, Arne Jansen wrote:
>>> On 11/21/2011 05:06 PM, Phillip Susi wrote:
>>>> On 7/10/2011 4:21 AM, Arne Jansen wrote:
>>>> I also have a question about the interactions with groups of groups. Say
>>>> I have 4 subvolumes: 1, 2, 3, and Z.  I group the first 3 volumes and
>>>> set a limit on them.  Now if all 3 volumes share a chunk of space, that
>>>> space should only count towards the group once, rather than 3 times.
>>>
>>> It's just what groups are made for. In your scenario the chunk of space
>>> would count only once. Some hopefully better explanation can be found at
>>
>> Ohh, so the group is a union of the chunks in the members, not a sum? So
>> if you set an exclusive limit on the group, that would count everything
>> shared between 1, 2, 3 once, and not count any shared with Z?  In other
>> words, --exclusive excludes space shared with things outside the group,
>> not within it?
> 
> Right. I think I haven't implemented limiting exclusive yet, but that's
> no big deal, if you have a use case for it. Tracking of exclusive is
> implemented.

Just looked at the source, it is implemented :)

>>
>> Not yet; I just found it today from the new thread on the subject, and
>> look forward to playing with it tonight.  I was wondering what revision
>> the patches are based on, and are they in a public git repo?
> 
> I can rebase it to the current for-linus and push it out later today.
> 

git://git.kernel.org/pub/scm/linux/kernel/git/arne/linux-btrfs.git qgroups

just waiting for the replication to the mirrors...
