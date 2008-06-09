From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: Re: btrfs device management
Date: Mon, 9 Jun 2008 16:37:15 +0100
Message-ID: <f058a9c30806090837k3a6d18afm942acd9c257c677@mail.gmail.com>
References: <62325.68.145.107.21.1212882817.squirrel@avalon.arbitraryconstant.com>
	 <20080609064358.GA27849@infradead.org>
	 <20080609060609.01e5c1d6@think.oraclecorp.com>
	 <f058a9c30806090645t12ad82f6pcb52c12a038897ed@mail.gmail.com>
	 <1213019571.10187.12.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Christoph Hellwig" <hch@infradead.org>,
	btrfs-devel@arbitraryconstant.com, linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1213019571.10187.12.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 9, 2008 at 2:52 PM, Chris Mason <chris.mason@oracle.com> wrote:
> On Mon, 2008-06-09 at 14:45 +0100, Miguel Sousa Filipe wrote:
>> Hi all,
>>
>> On Mon, Jun 9, 2008 at 11:06 AM, Chris Mason <chris.mason@oracle.com> wrote:
>> > On Mon, 9 Jun 2008 02:43:58 -0400
>> > Christoph Hellwig <hch@infradead.org> wrote:
>> >
>> >> On Sat, Jun 07, 2008 at 05:53:37PM -0600,
>> >
>> >> Yes, I plan to work on adding properly designed multiple device
>> >> support for btrfs and my upcoming similar xfs work.  I'll live in
>> >> good old mount and libvolume_id.
>> >>
>> >
>> > I won't say no to a mount patch either.  The only downside is that
>> > we'll need to update it (in mount) as the format goes through changes
>> > over the summer.  But that is a temporary problem.
>>
>>
>> I believe that a multi-volume filesystem should have some kind of
>> human understandable handle/name.
>> Just like a name of a logical volume. For single disks filesystems,
>> the disk name suffices (and reduced the need for such a name/label),
>> but in multi-disk FS there should still be a humane name for that
>> mountpoint or filesystem.
>> So, while any unique identifier would technically be okay, I think
>> that there should be a human undertanble name/label for it. Not just
>> some uid.
>>
>> Does Hellwig work, or any planned feature provide this ?
>
> mkfs.btrfs already has a way to set the label of the filesystem.
> mkfs.btrfs -L label /dev/xxxx
>
> btrfs-show will show you the labels of any existing filesystems.
>

Can I mount by label ?
something like:
# mount /dev/btrfs/label /mountpoint

> In practice, anyone on a san really wants to use uuids.  Labels are nice
> until two people on the same san create a filesystem named system, and
> then it all gets ugly ;)

It can make sense to use uuids there, (Although that looks to me like
a comunication problem)..
But replacing a human readable id with a unreadable one will worsen
the usability and
make it more dificult on a lot of scenarios were uuids aren't needed.
UUID doesn't solve a very common requisite: having a human readable
name for a volume/mountpoint/filesystem.

Kind regards,


-- 
Miguel Sousa Filipe
