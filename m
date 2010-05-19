From: Andy Lutomirski <luto@mit.edu>
Subject: Re: Rename+crash behaviour of btrfs - nearly ext3!
Date: Tue, 18 May 2010 21:34:27 -0400
Message-ID: <4BF34023.9090805@mit.edu>
References: <4BF18525.8080904@gmail.com> <20100517193652.GC8635@think> <4BF1DBCD.7060208@gmail.com> <20100518003032.GK8635@think> <20100518005926.GM8635@think> <4BF28225.2000908@gmail.com> <20100518131304.GX8635@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Jakob Unterwurzacher <jakobunt@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100518131304.GX8635@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Tue, May 18, 2010 at 02:03:49PM +0200, Jakob Unterwurzacher wrote:
>> On 18/05/10 02:59, Chris Mason wrote:
>>>>> Ok, I upgraded to 2.6.34 final and switched to defconfig.
>>>>> I only did the rename test ( i.e. no overwrite ), the window is now
>>>>> 1.1s, both with vanilla and with the patch.
>>>> Thanks, so much for the easy fix.  I'll take a look.
>>> Ohhhhh, I read your initial email wrong, I'm sorry.  The test we're
>>> failing, the rentest, doesn't overwrite one file with another.  It is
>>> just creating a file and then renaming it.
>> Yes, the overwrite test goes perfectly fine.
>>
>>> Btrfs is explicitly choosing not to sync the file in this case because
>>> the rename isn't replacing good old data with new unwritten data.  The
>>> rename is taking new unwritten data and giving it a different name.
>>>
>>> Are there applications that rely on this? 
>>>
>>> -chris
>> Well, dpkg (the Debian/Ubuntu package manager) did. Then ext4 became the
>> default fs in Ubuntu and massive breakage was reported [1]. Now dpkg is
>> fsync()ing everything and is about 2x slower than it was with ext3 [2].
>>
>> Btrfs is so close to getting it "right" that i wondered whether the new
>> file name hitting the disk could be delayed that one second for the data
>> to make it to disk first.
>>
> 
> The thing is that different apps have a different version of 'right'.  Rename
> is atomically replacing one file with another, and I completely agree
> that when we have an established file on disk, we shouldn't replace it
> with something that is potentially garbage.
> 
> But for the zeros case we have a file that isn't on disk and we're just
> giving it a new name.  I can see a different class of applications
> getting upset about renames slowing the system down dramatically because
> they suddenly imply a lot of IO.
> 
> I'm more than open to discussion on this one, but I don't see how:
> 
> rm -f foo2
> dd if=/dev/zero of=foo bs=1M count=1000
> mv foo foo2
> 
> Should be expected to write 1GB of data.

[disclaimer: I don't know much about btrfs internals]

foo2 being gone after a crash is, of course, fine.  But, depending on 
the programmer, there are a few answers:

1. I want foo2 to either not exist or to contain the data I just wrote. 
  So please wait for it to hit disk.

2. I want foo2 to either not exist or to contain the data I just wrote. 
  So, btrfs, please learn how to make sure that the metadata doesn't get 
written until the data gets written.  Presumably this means that the 
rename needs to go into a log somewhere (in memory) but not become a 
part of the current transaction to avoid all kinds of latency.

3. I want speed.  Do whatever's fastest.

Of course, there's a harder case:

dd if=/dev/zero of=foo bs=1M count=1000
mv foo foo2
dd if=<something else> of=foo2 bs=1k count=1

Now what?


A lot of application programmers probably want the metadata to happen 
after the data, but they don't want to use fsync because they don't want 
to wait for anything to hit disk.  It would be nice to ask the FS for 
help, but that might be distinctly nontrivial.

--Andy
