From: "Miguel Figueiredo Mascarenhas Sousa Filipe"
	<miguel.filipe@gmail.com>
Subject: Re: Selective Compression/Encryption
Date: Tue, 9 Dec 2008 22:14:19 +0000
Message-ID: <f058a9c30812091414n3834309cn5cdef0760c757abd@mail.gmail.com>
References: <20081209145952.GA30494@tux64-03>
	 <f058a9c30812090745v15b5f983u468b560ae791dc37@mail.gmail.com>
	 <200812091722.21567.mail@earthworm.de>
	 <20081209180951.GA6551@tux64-03>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Christian Hesse" <mail@earthworm.de>, linux-btrfs@vger.kernel.org
To: "Lee Trager" <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081209180951.GA6551@tux64-03>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 9, 2008 at 6:09 PM, Lee Trager <lt73@cs.drexel.edu> wrote:
> On Tue, Dec 09, 2008 at 05:22:18PM +0100, Christian Hesse wrote:
>> On Tuesday 09 December 2008, Miguel Figueiredo Mascarenhas Sousa Filipe wrote:
>> > Hi there,
>> >
>> > On Tue, Dec 9, 2008 at 2:59 PM, Lee Trager <lt73@cs.drexel.edu> wrote:
>> > > Currently compression and I assume if encryption is implemented it is
>> > > turned on or off during mount. There are however many times when a user
>> > > may want to select which files/directories they want to compress or
>> > > encrypt. This will also be helpful when implementing btrfs support in
>> > > grub for example. We can say the disk can be compressed/encrypted except
>> > > for /boot so compression/encryption doesn't have to be implemented in
>> > > grub.
>>
>> You could just use an additional partition for /boot that has compression an
>> encryption disabled...
>>
> Yes you could but many distributions are moving away from that such as
> ubuntu. Also while this works well on desktop and server environments
> where space is not an issue on embedded systems where free space is
> measured in kb or mb it starts becomming a huge issue.
>
>> > > I was thinking of adding this functionality to the userspace application
>> > > btrfstune. The way I was thinking of doing this is when btrfstune +c is
>> > > applied to a directory or file the directory(and all its contents) or
>> > > file will always be compressed reguardless of how the filesystem is
>> > > mounted. The opposite would happen when btrfstune -c is used.
>> > >
>> > > Would this be a reasonable thing to implement? Any suggestions before I
>> > > start doing this?
>> >
>> > Things like compression or encription should be used at the "volume" level.
>>
>> That was what I said some time ago when I asked why encryption support for
>> btrfs is planned. On a volume level you can use dm-crypt and the fs can
>> ignore that part completely.
>>
>> The answer was that different users on a home partition could use their own
>> encryption key. That sounds like volume level is out of bet. ;)
>>
> It does seem that doing it with volumes would limit user control and add
> lots of complexity to such a simple task.
>
> Miguel, what is your reason for suggesting this be done at the volume level?

Well, basically, the main issue I have with file level configuration,
is maintenance nightmare in the long term.

Redundancy level settings (raid0,1,5,6..), and compression/encription,
to me, seem like a sub-volume setting.
Its the right granularity to manage and mantain data and interact with it.
If I want this folders compressed.. I can just move them to my
compressed sub-vol.
If I want files: a, b/weird_path/D, and NSA/* confidential, I put them
in my encripted sub-vol.

Imagine working on a confidencial project, where you add new
files/folders practilly everyday, and every single day, you must
remember to (and bother to do extra word so that..) set that file as a
encripted one.

Also, by using sub-vols like this, and if redudancy is applied at the
same level, things just play nice, I can have distinct mount-points
that represent data that I want with a given set of
redundancy/compression and encription rules.

It becomes easier to mantain, and use.

Just imagine having a "confidencial" or a "compressed" mountpoint/disk
 ICON in you desktop, and just knowing that files in there are
encripted and/or compressed.
Versus, having to browser your file and look for a specific
"encripted" or "compressed" flag, that the file explorer shows if they
play nice...

Now... if its at the file level, It can be troublesome to look for
allfiles encripted/compressed.
Also, knowing the encription key to each file (if it's set at the file
level) ... argh!!


Doing this file based, seems to me that will lead to complication the
long term maintenance of things.

In the long term, when someone picks up, or mounts a old, used system,
I can't imagine the butload of work involved in finding out things
like:
- what in this 4TB fs is compressed, what is encripted?
- (in case of redundancy at the file level): how many redundancy
levels do I have, and which files respectively?
- why is rsync/scp 'ing this folder/BIG_NESTED_TREE_OF_FILES allways
"stop" at folder/**/fileB and folder/z*/* ?
 (might it be that some unsuspecting file in there has a trully beasty
compression ratio, and that 4GB fileB (in the middle of other 4GB
files), is instead a 80Gb file compressed ?


I also don't like extended attributes, we're just creating a whole new
orthogonal dimension/namespace were we store/manipulate information..
it also complicates backups (does the backup system understand and
respects ext. attrs?)

It's messier doing these things with extended attributes or very
custom tools, instead of levelaging/creating a volume management tool,
for managing this, such tool will allready be there to manage the
fisical storage <-> filesystems/volumes mappings and settings.. might
has well leverage it.



Kind regards,



>
>> > So.. if a user wants a specific set of files or dirs ..they should
>> > create a mount-point/volume like:
>> >
>> > private_vol
>> > bigarchives_vol
>> >
>> > and set those volumes as compressed or encripted volumes
>> >
>> > Regarding usability, the best would be for the sub-volume creation
>> > tool to optionally allow passing encription/compression arguments.
>> >
>> >
>> > and then:
>> >  should mount those volumes somewhere like: ~/Confidential or ~/Archives.
>> >
>> > Basically, do it at the directory level (which in btrfs is at the
>> > sub-volume level).
>> > File-level granularity is totally unmanageable in the long term.
>> >
>> > Kind regards,
>>
>> --
>> Regards,
>> Chris
>
> Lee
>



-- 
Miguel Sousa Filipe
