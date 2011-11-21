From: Arne Jansen <sensille@gmx.net>
Subject: Re: [RFC] Subvolume Quota on-disk structures and configuration
Date: Mon, 21 Nov 2011 18:20:07 +0100
Message-ID: <4ECA8847.2080905@gmx.net>
References: <4E19611D.2090007@gmx.net> <4ECA7721.3040607@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ECA7721.3040607@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/21/2011 05:06 PM, Phillip Susi wrote:
> On 7/10/2011 4:21 AM, Arne Jansen wrote:
>> btrfs qgroup limit [--exclusive] <size>|none <qgroupid> <path>
>>
>>
>> btrfs qgroup limit 10g /usr
>>
>> That should be simple enough for the common use case.
> 
> Wouldn't that make the syntax above actually be:
> 
> btrfs qgroup limit [--exclusive] <size|none> [qgroupid] <path>

You don't mean to actually changing the syntax, but adding a better
explanation or a more precise usage?

> 
> Since the qgroupid is optional?  And the meaning of path depends on
> whether or not qgroupid is specified.  With qgroupid, path is anywhere
> on the fs, but without it, it specifies the path of the implicit
> qgroupid, right?
> 
> I also have a question about the interactions with groups of groups. Say
> I have 4 subvolumes: 1, 2, 3, and Z.  I group the first 3 volumes and
> set a limit on them.  Now if all 3 volumes share a chunk of space, that
> space should only count towards the group once, rather than 3 times.

It's just what groups are made for. In your scenario the chunk of space
would count only once. Some hopefully better explanation can be found at

http://sensille.com/qgroups.pdf

Have you already played with the patchset?

-Arne

> You might think the solution to that is to use the exclusive limits, but
> that would mean that any space volume 3 and volume Z share would not be
> counted in the group at all.  I don't care about volume Z since it is
> not part of the group, yet it can influence the used space of the
> group.  Likewise, if I set an exclusive limit on the group, and then
> create snapshot Y from subvol 2, that would significantly reduce the
> exclusive charge for the group, and we don't want that.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

