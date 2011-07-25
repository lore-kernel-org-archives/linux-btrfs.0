From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v7 0/8] Btrfs scrub: print path to corrupted files and
 trigger nodatasum fixup
Date: Mon, 25 Jul 2011 15:15:03 +0200
Message-ID: <4E2D6C57.7020302@jan-o-sch.net>
References: <cover.1311333004.git.list.btrfs@jan-o-sch.net> <loom.20110724T002821-609@post.gmane.org> <4E2C03CD.1000004@jan-o-sch.net> <4E2C0E2C.4070606@GMX.li> <4E2C1E9D.1090403@jan-o-sch.net> <4E2C8425.9090601@GMX.li> <4E2D2A8F.1050206@jan-o-sch.net> <4E2D5C36.306@GMX.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jan Schubert <Jan.Schubert@GMX.li>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E2D5C36.306@GMX.li>
List-ID: <linux-btrfs.vger.kernel.org>

On 25.07.2011 14:06, Jan Schubert wrote:
> On 07/25/2011 10:34 AM, Jan Schmidt wrote:
>> On 24.07.2011 22:44, Jan Schubert wrote:
>>> Any chance to resolve the inodes to affected files manualy?
>> That's cumbersome, but you can do it using the information contained in
>> the debug-tree output. But I'd rather find the bug I must have
>> introduced :-)
> 
> Thx, let me know when there is a new patch available. I did a search for
> the inodes listed in dmesg but could not find all of them in the debug
> tree. And for the ones I found it looks not soo easy to match them to
> filenames.

Look for "key (<inum> INODE_REF" in your output, replacing "<inum>" with
the actual inode number. In the next line you'll find the name of the
file. To construct the path, you need to go back to the parent and
lookup its name the same way. The parent inode is the number behind the
"INODE_REF" part in the key.

> BTW: What is the option -e for btrfs-debug-tree meaning? If I try to use
> it I just get an segfault right after starting:
> 
> btrfs-debug-tre[1875]: segfault at c4 ip 000000000040a839 sp
> 00007fff9498ff50 error 4 in btrfs-debug-tree[400000+1c000]

No, never used it.

>>> Are you interested in btrfs-debug-tree anyway?
>> Absolutely, yes.
>>
>> Alternatively, if you have a lot of bandwidth and no private data in
>> your file system, it would be even more helpful if you put the whole
>> file system somewhere. But the btrfs-debug-tree output would help a lot,
>> too.
> 
> Jan, what if there are some private data inside? Will you use it for
> other purposes than debugging? I understood that there are "just"
> filenames listet in there, no content, right?

Whatever you provide will of course only be used for debugging purposes.
But I can totally understand if you don't want to provide the full file
system. I wouldn't either, I guess.

The debug tree output contains meta data only, including all file names
but no actual data.

> The bziped debugtree is about 39M in size, I would be able to provide a
> download for you!?

That would be great. Where can I get it? Send me an off-list reply or
contact me on freenode irc (janosch) if you don't want it on the list.

-Jan
