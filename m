From: "Jeff Schroeder" <jeffschroed@gmail.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 05:48:30 -0700
Message-ID: <c24352ca0810220548h4f383b32u18efa44251797b3d@mail.gmail.com>
References: <20081021132322.271ad728.skraw@ithnet.com>
	 <1224597580.27474.93.camel@think.oraclecorp.com>
	 <20081021182710.a12f4914.skraw@ithnet.com>
	 <1224611383.27474.140.camel@think.oraclecorp.com>
	 <20081022141906.f6529c6d.skraw@ithnet.com>
Reply-To: jeffschroeder@computer.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Chris Mason" <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: "Stephan von Krawczynski" <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081022141906.f6529c6d.skraw@ithnet.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 22, 2008 at 5:19 AM, Stephan von Krawczynski
<skraw@ithnet.com> wrote:
> On Tue, 21 Oct 2008 13:49:43 -0400
> Chris Mason <chris.mason@oracle.com> wrote:
>
>> On Tue, 2008-10-21 at 18:27 +0200, Stephan von Krawczynski wrote:
>>
>> > > > 2. general requirements
>> > > >     - fs errors without file/dir names are useless
>> > > >     - errors in parts of the fs are no reason for a fs to go offline as a whole
>> > >
>> > > These two are in progress.  Btrfs won't always be able to give a file
>> > > and directory name, but it will be able to give something that can be
>> > > turned into a file or directory name.  You don't want important
>> > > diagnostic messages delayed by name lookup.
>> >
>> > That's a point I really never understood. Why is it non-trivial for a fs to
>> > know what file or dir (name) it is currently working on?
>>
>> The name lives in block A, but you might find a corruption while
>> processing block B.  Block A might not be in ram anymore, or it might be
>> in ram but locked by another process.
>>
>> On top of all of that, when we print errors it's because things haven't
>> gone well.  They are deep inside of various parts of the filesystem, and
>> we might not be able to take the required locks or read from the disk in
>> order to find the name of the thing we're operating on.
>
> Ok, this is interesting. In another thread I was told parallel mounts are
> really complex and you cannot do good things in such an environment that you
> can do with single mount. Well, then, why don't we do it? All boxes I know
> have tons of RAM, but fs finds no place in RAM to put large parts (if not all)
> of the structural fs data including filenames? Besides the simple fact that
> RAM is always faster than any known disk be it rotating or not, and that RAM
> is just there, whats the word for not doing it?

Google "Daniel Phillips Ramback faster than a speeding bullet". He is on this
list and may have some insight.

>> > > >     - parallel mounts (very important!)
>> > > >       (two or more hosts mount the same fs concurrently for reading and
>> > > >       writing)
>> > >
>> > > As Jim and Andi have said, parallel mounts are not in the feature list
>> > > for Btrfs.  Network filesystems will provide these features.
>> >
>> > Can you explain what "network filesystems" stands for in this statement,
>> > please name two or three examples.
>> >
>> NFS (done) CRFS (under development), maybe ceph as well which is also
>> under development.
>
> NFS is a good example for a fs that never got redesigned for modern world. I
> hope it will, but currently it's like Model T on a highway.
> You have a NFS server with clients. Your NFS server dies, your backup server
> cannot take over the clients without them resetting their NFS-link (which
> means reboot to many applications) - no way.
> Besides that you still need another fs below NFS to bring your data onto some
> medium, which means you still have the problem how to create redundancy in
> your server architecture.

You are somewhat misinformed on this. Perhaps the Linux nfs server can't cope,
but I doubt it. NFS was designed to be stateless. I've got a fair
amount of experience
with a dual head netapp architecture. When 1 head dies, the other
transparently fails
over. During the brief downtime, the clients will go into I/O wait if
at all instead of being
disconnected. You might be able to do something similar using nfsd and
keepalived if
both servers were connected to the same storage. Setting that up would
be trivial. You
just need the clients mounting the vip and a reliable mechanism to
provide the data from
that vip. You could use heartbeat, but it is overly complex. Also look
at clustered nfs or
pnfs, both of which are nfs redesigns like you speak of.

-- 
Jeff Schroeder

Don't drink and derive, alcohol and analysis don't mix.
http://www.digitalprognosis.com
