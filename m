From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v7 0/8] Btrfs scrub: print path to corrupted files and
 trigger nodatasum fixup
Date: Tue, 26 Jul 2011 19:36:00 +0200
Message-ID: <4E2EFB00.2000302@jan-o-sch.net>
References: <cover.1311333004.git.list.btrfs@jan-o-sch.net> <loom.20110724T002821-609@post.gmane.org> <4E2C03CD.1000004@jan-o-sch.net> <4E2C0E2C.4070606@GMX.li> <4E2C1E9D.1090403@jan-o-sch.net> <4E2C8425.9090601@GMX.li> <4E2D2A8F.1050206@jan-o-sch.net> <4E2D5C36.306@GMX.li> <4E2D6C57.7020302@jan-o-sch.net> <4E2D9290.6020600@GMX.li> <4E2E912E.7040109@jan-o-sch.net> <4E2E92FA.4060008@GMX.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Jan Schubert <Jan.Schubert@GMX.li>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E2E92FA.4060008@GMX.li>
List-ID: <linux-btrfs.vger.kernel.org>



On 26.07.2011 12:12, Jan Schubert wrote:
> On 07/26/2011 12:04 PM, Jan Schmidt wrote:
>> On 25.07.2011 17:58, Jan Schubert wrote:
>>> btrfs: unable to fixup at 182245531648
>>> btrfs: unable to fixup at 182245535744
>>> btrfs: unable to fixup at 182245539840
>> This is due to rate limitation of printk() to prevent flooding. I'd like
>> to continue discussion of this problem on the list, but I didn't reply
>> to the list this time due to the debug-tree link you gave me.
> 
> OK, go on Jan, no problem. Is there any chance to use the numbers above
> to identify related files?

Thanks for sending the debug-tree output. Turns out that there is a
quite obvious bug in my code for extents that have refs but no inline
ref at all.

I'll fix this up and send a new version (hooray).

Jan: It would be nice if you could try the new patch set once I've sent
it. I don't need any additional input from you at the moment.

Chris: As you suggested, the new version will also include two separate
size fields in struct btrfs_data_container, which then can both be unsigned.

-Jan
