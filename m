From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Kernel BUG in tree-log.c on mount
Date: Fri, 16 Oct 2009 11:11:14 +0800
Message-ID: <3d0408630910152011w15fbbcdbj8f324b2c943cc3d7@mail.gmail.com>
References: <cb81ffa90910142048g4aa9a30fmca8e5ce7007d13e1@mail.gmail.com>
	 <3d0408630910151907y2748c5bdv3000a38a982aa25d@mail.gmail.com>
	 <cb81ffa90910151940y426ff7d7wa1e545102a17de69@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cb81ffa90910151940y426ff7d7wa1e545102a17de69@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

n Fri, Oct 16, 2009 at 10:40 AM, David Pflug <dtpflug@gmail.com> wrote:
> On Thu, Oct 15, 2009 at 10:07 PM, Yan, Zheng <yanzheng@21cn.com> wrote:
>> On Thu, Oct 15, 2009 at 11:48 AM, David Pflug <dtpflug@gmail.com> wrote:
>>> I don't know if there's any useful data in this dump, for you guys. I
>>> can get you the output of btrfs-debug-tree as well, if it'd be
>>> helpful.
>>
>> We never saw this bug before, please send the output of btrfs-debug-tree.
> http://tpflug.name/btrfs_debug_tree.txt.bz2

log tree key (TREE_LOG ROOT_ITEM 5)
leaf 1453862912 items 9 free space 2349 generation 4803 owner 1
fs uuid a369f9c7-c3c4-40bd-a191-907f79f51205
chunk uuid 20df5ed7-f708-437d-b297-a4372ca67a7d
	item 0 key (EXTENT_TREE ROOT_ITEM 0) itemoff 3756 itemsize 239
		root data bytenr 1450123264 level 2 dirid 0 refs 1
	item 1 key (DEV_TREE ROOT_ITEM 0) itemoff 3517 itemsize 239
		root data bytenr 1517395968 level 0 dirid 0 refs 1
	item 2 key (FS_TREE INODE_REF 6) itemoff 3500 itemsize 17
		inode ref index 0 namelen 7 name: default
	item 3 key (FS_TREE ROOT_ITEM 0) itemoff 3261 itemsize 239
		root data bytenr 1449054208 level 3 dirid 256 refs 1
	item 4 key (ROOT_TREE_DIR INODE_ITEM 0) itemoff 3101 itemsize 160
		inode generation 4 size 0 block group 0 mode 40555 links 1
	item 5 key (ROOT_TREE_DIR INODE_REF 6) itemoff 3089 itemsize 12
		inode ref index 0 namelen 2 name: ..
	item 6 key (ROOT_TREE_DIR DIR_ITEM 2378154706) itemoff 3052 itemsize 37
		location key (FS_TREE ROOT_ITEM 18446744073709551615) type 2
		namelen 7 datalen 0 name: default
	item 7 key (CSUM_TREE ROOT_ITEM 0) itemoff 2813 itemsize 239
		root data bytenr 1449447424 level 2 dirid 0 refs 1
	item 8 key (DATA_RELOC_TREE ROOT_ITEM 0) itemoff 2574 itemsize 239
		root data bytenr 29380608 level 0 dirid 256 refs 1

The contents of log tree is the same as root tree. I guess the block
group caching bug is the cause.

Yan, Zheng
