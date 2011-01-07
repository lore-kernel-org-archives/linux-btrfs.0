From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: "open_ctree failed", unable to mount the fs
Date: Fri, 07 Jan 2011 20:25:13 +0100
Message-ID: <4D276899.7000702@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> The forthcoming[1] btrfsck tool should handle that particular
> error, I believe.

I noticed a similar problem was discussed here, with a solution:

http://www.spinics.net/lists/linux-btrfs/msg07572.html


where a "btrfs-selects-super" was used:

> git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
> next
> 
> (or git pull into your existing checkout)
> 
> Then
> 
> make btrfs-select-super
> ./btrfs-selects-super -s 1 /dev/xxx
> 
> After this you'll want to do a full backup and make sure things are
> working properly.


However, I don't see the tool when I clone the latest git - am I missing something?


FYI, "btrfsck -s 1 /dev/vda3" says:

using SB copy 1, bytenr 67108864
fs tree 265 refs 1 not found
	unresolved ref root 284 dir 115450 index 2 namelen 19 name 2010-10-17-05:15:23 error 600
fs tree 274 refs 1 not found
	unresolved ref root 284 dir 115450 index 3 namelen 19 name 2010-10-24-05:15:20 error 600
fs tree 277 refs 1 not found
	unresolved ref root 284 dir 115392 index 20 namelen 19 name 2010-10-26-05:15:21 error 600
fs tree 278 refs 1 not found
	unresolved ref root 284 dir 115392 index 21 namelen 19 name 2010-10-27-05:15:23 error 600
fs tree 279 refs 1 not found
	unresolved ref root 284 dir 115392 index 22 namelen 19 name 2010-10-28-05:18:28 error 600
fs tree 280 refs 1 not found
	unresolved ref root 284 dir 115392 index 23 namelen 19 name 2010-10-29-05:15:21 error 600
fs tree 281 refs 1 not found
	unresolved ref root 284 dir 115392 index 24 namelen 19 name 2010-10-30-05:15:27 error 600
fs tree 282 refs 1 not found
	unresolved ref root 284 dir 115450 index 4 namelen 19 name 2010-10-31-05:15:21 error 600
fs tree 283 refs 1 not found
	unresolved ref root 284 dir 115392 index 25 namelen 19 name 2010-10-31-05:15:21 error 600
fs tree 284 refs 13 
	unresolved ref root 284 dir 115453 index 2 namelen 19 name 2010-11-01-05:15:26 error 600
	unresolved ref root 319 dir 115453 index 2 namelen 19 name 2010-11-01-05:15:26 error 600
	unresolved ref root 340 dir 115453 index 2 namelen 19 name 2010-11-01-05:15:26 error 600
	unresolved ref root 348 dir 115453 index 2 namelen 19 name 2010-11-01-05:15:26 error 600
	unresolved ref root 355 dir 115453 index 2 namelen 19 name 2010-11-01-05:15:26 error 600
	unresolved ref root 357 dir 115453 index 2 namelen 19 name 2010-11-01-05:15:26 error 600
	unresolved ref root 358 dir 115453 index 2 namelen 19 name 2010-11-01-05:15:26 error 600
	unresolved ref root 359 dir 115453 index 2 namelen 19 name 2010-11-01-05:15:26 error 600
	unresolved ref root 360 dir 115453 index 2 namelen 19 name 2010-11-01-05:15:26 error 600
	unresolved ref root 361 dir 115453 index 2 namelen 19 name 2010-11-01-05:15:26 error 600
	unresolved ref root 362 dir 115453 index 2 namelen 19 name 2010-11-01-05:15:26 error 600
	unresolved ref root 363 dir 115453 index 2 namelen 19 name 2010-11-01-05:15:26 error 600
fs tree 299 refs 1 not found
	unresolved ref root 319 dir 115450 index 6 namelen 19 name 2010-11-14-05:15:25 error 600
fs tree 307 refs 1 not found
	unresolved ref root 319 dir 115450 index 7 namelen 19 name 2010-11-21-05:18:23 error 600
fs tree 312 refs 1 not found
	unresolved ref root 319 dir 115392 index 50 namelen 19 name 2010-11-25-05:15:25 error 600
fs tree 313 refs 1 not found
	unresolved ref root 319 dir 115392 index 51 namelen 19 name 2010-11-26-05:15:24 error 600
fs tree 314 refs 1 not found
	unresolved ref root 319 dir 115392 index 52 namelen 19 name 2010-11-27-05:15:27 error 600
fs tree 315 refs 2 not found
	unresolved ref root 319 dir 115450 index 8 namelen 19 name 2010-11-28-05:15:22 error 600
	unresolved ref root 340 dir 115450 index 8 namelen 19 name 2010-11-28-05:15:22 error 600
fs tree 316 refs 1 not found
	unresolved ref root 319 dir 115392 index 53 namelen 19 name 2010-11-28-05:15:22 error 600
fs tree 317 refs 1 not found
	unresolved ref root 319 dir 115392 index 54 namelen 19 name 2010-11-29-05:15:25 error 600
fs tree 318 refs 1 not found
	unresolved ref root 319 dir 115392 index 55 namelen 19 name 2010-11-30-05:15:24 error 600
fs tree 319 refs 12 
	unresolved ref root 319 dir 115453 index 3 namelen 19 name 2010-12-01-05:15:29 error 600
	unresolved ref root 340 dir 115453 index 3 namelen 19 name 2010-12-01-05:15:29 error 600
	unresolved ref root 348 dir 115453 index 3 namelen 19 name 2010-12-01-05:15:29 error 600
	unresolved ref root 355 dir 115453 index 3 namelen 19 name 2010-12-01-05:15:29 error 600
	unresolved ref root 357 dir 115453 index 3 namelen 19 name 2010-12-01-05:15:29 error 600
	unresolved ref root 358 dir 115453 index 3 namelen 19 name 2010-12-01-05:15:29 error 600
	unresolved ref root 359 dir 115453 index 3 namelen 19 name 2010-12-01-05:15:29 error 600
	unresolved ref root 360 dir 115453 index 3 namelen 19 name 2010-12-01-05:15:29 error 600
	unresolved ref root 361 dir 115453 index 3 namelen 19 name 2010-12-01-05:15:29 error 600
	unresolved ref root 362 dir 115453 index 3 namelen 19 name 2010-12-01-05:15:29 error 600
	unresolved ref root 363 dir 115453 index 3 namelen 19 name 2010-12-01-05:15:29 error 600
fs tree 324 refs 2 not found
	unresolved ref root 340 dir 115450 index 9 namelen 19 name 2010-12-05-05:15:29 error 600
	unresolved ref root 348 dir 115450 index 9 namelen 19 name 2010-12-05-05:15:29 error 600
fs tree 332 refs 5 not found
	unresolved ref root 340 dir 115450 index 10 namelen 19 name 2010-12-12-05:15:32 error 600
	unresolved ref root 348 dir 115450 index 10 namelen 19 name 2010-12-12-05:15:32 error 600
	unresolved ref root 355 dir 115450 index 10 namelen 19 name 2010-12-12-05:15:32 error 600
	unresolved ref root 357 dir 115450 index 10 namelen 19 name 2010-12-12-05:15:32 error 600
	unresolved ref root 358 dir 115450 index 10 namelen 19 name 2010-12-12-05:15:32 error 600
fs tree 334 refs 1 not found
	unresolved ref root 340 dir 115392 index 68 namelen 19 name 2010-12-13-05:15:28 error 600
fs tree 335 refs 1 not found
	unresolved ref root 340 dir 115392 index 69 namelen 19 name 2010-12-14-05:15:37 error 600
fs tree 336 refs 1 not found
	unresolved ref root 340 dir 115392 index 70 namelen 19 name 2010-12-15-05:15:37 error 600
fs tree 337 refs 1 not found
	unresolved ref root 340 dir 115392 index 71 namelen 19 name 2010-12-16-05:15:31 error 600
fs tree 338 refs 1 not found
	unresolved ref root 340 dir 115392 index 72 namelen 19 name 2010-12-17-05:15:39 error 600
fs tree 339 refs 1 not found
	unresolved ref root 340 dir 115392 index 73 namelen 19 name 2010-12-18-05:15:34 error 600
fs tree 340 refs 11 
	unresolved ref root 340 dir 115450 index 11 namelen 19 name 2010-12-19-05:15:26 error 600
	unresolved ref root 348 dir 115450 index 11 namelen 19 name 2010-12-19-05:15:26 error 600
	unresolved ref root 355 dir 115450 index 11 namelen 19 name 2010-12-19-05:15:26 error 600
	unresolved ref root 357 dir 115450 index 11 namelen 19 name 2010-12-19-05:15:26 error 600
	unresolved ref root 358 dir 115450 index 11 namelen 19 name 2010-12-19-05:15:26 error 600
	unresolved ref root 359 dir 115450 index 11 namelen 19 name 2010-12-19-05:15:26 error 600
	unresolved ref root 360 dir 115450 index 11 namelen 19 name 2010-12-19-05:15:26 error 600
	unresolved ref root 361 dir 115450 index 11 namelen 19 name 2010-12-19-05:15:26 error 600
	unresolved ref root 362 dir 115450 index 11 namelen 19 name 2010-12-19-05:15:26 error 600
	unresolved ref root 363 dir 115450 index 11 namelen 19 name 2010-12-19-05:15:26 error 600
fs tree 342 refs 1 not found
	unresolved ref root 348 dir 115392 index 75 namelen 19 name 2010-12-20-05:15:30 error 600
fs tree 343 refs 1 not found
	unresolved ref root 348 dir 115392 index 76 namelen 19 name 2010-12-21-05:15:36 error 600
fs tree 344 refs 1 not found
	unresolved ref root 348 dir 115392 index 77 namelen 19 name 2010-12-22-05:16:46 error 600
fs tree 345 refs 1 not found
	unresolved ref root 348 dir 115392 index 78 namelen 19 name 2010-12-23-05:15:26 error 600
fs tree 346 refs 1 not found
	unresolved ref root 348 dir 115392 index 79 namelen 19 name 2010-12-24-05:15:50 error 600
fs tree 347 refs 1 not found
	unresolved ref root 348 dir 115392 index 80 namelen 19 name 2010-12-25-05:15:36 error 600
fs tree 348 refs 10 
	unresolved ref root 348 dir 115450 index 12 namelen 19 name 2010-12-26-05:15:31 error 600
	unresolved ref root 355 dir 115450 index 12 namelen 19 name 2010-12-26-05:15:31 error 600
	unresolved ref root 357 dir 115450 index 12 namelen 19 name 2010-12-26-05:15:31 error 600
	unresolved ref root 358 dir 115450 index 12 namelen 19 name 2010-12-26-05:15:31 error 600
	unresolved ref root 359 dir 115450 index 12 namelen 19 name 2010-12-26-05:15:31 error 600
	unresolved ref root 360 dir 115450 index 12 namelen 19 name 2010-12-26-05:15:31 error 600
	unresolved ref root 361 dir 115450 index 12 namelen 19 name 2010-12-26-05:15:31 error 600
	unresolved ref root 362 dir 115450 index 12 namelen 19 name 2010-12-26-05:15:31 error 600
	unresolved ref root 363 dir 115450 index 12 namelen 19 name 2010-12-26-05:15:31 error 600
fs tree 349 refs 1 not found
	unresolved ref root 355 dir 115392 index 81 namelen 19 name 2010-12-26-05:15:31 error 600
fs tree 350 refs 3 not found
	unresolved ref root 355 dir 115392 index 82 namelen 19 name 2010-12-27-05:15:28 error 600
	unresolved ref root 357 dir 115392 index 82 namelen 19 name 2010-12-27-05:15:28 error 600
	unresolved ref root 358 dir 115392 index 82 namelen 19 name 2010-12-27-05:15:28 error 600
fs tree 351 refs 4 not found
	unresolved ref root 355 dir 115392 index 83 namelen 19 name 2010-12-28-05:15:27 error 600
	unresolved ref root 357 dir 115392 index 83 namelen 19 name 2010-12-28-05:15:27 error 600
	unresolved ref root 358 dir 115392 index 83 namelen 19 name 2010-12-28-05:15:27 error 600
	unresolved ref root 359 dir 115392 index 83 namelen 19 name 2010-12-28-05:15:27 error 600
fs tree 352 refs 5 not found
	unresolved ref root 355 dir 115392 index 84 namelen 19 name 2010-12-29-05:15:35 error 600
	unresolved ref root 357 dir 115392 index 84 namelen 19 name 2010-12-29-05:15:35 error 600
	unresolved ref root 358 dir 115392 index 84 namelen 19 name 2010-12-29-05:15:35 error 600
	unresolved ref root 359 dir 115392 index 84 namelen 19 name 2010-12-29-05:15:35 error 600
	unresolved ref root 360 dir 115392 index 84 namelen 19 name 2010-12-29-05:15:35 error 600
fs tree 353 refs 6 not found
	unresolved ref root 355 dir 115392 index 85 namelen 19 name 2010-12-30-05:15:32 error 600
	unresolved ref root 357 dir 115392 index 85 namelen 19 name 2010-12-30-05:15:32 error 600
	unresolved ref root 358 dir 115392 index 85 namelen 19 name 2010-12-30-05:15:32 error 600
	unresolved ref root 359 dir 115392 index 85 namelen 19 name 2010-12-30-05:15:32 error 600
	unresolved ref root 360 dir 115392 index 85 namelen 19 name 2010-12-30-05:15:32 error 600
	unresolved ref root 361 dir 115392 index 85 namelen 19 name 2010-12-30-05:15:32 error 600
fs tree 354 refs 7 not found
	unresolved ref root 355 dir 115392 index 86 namelen 19 name 2010-12-31-05:15:38 error 600
	unresolved ref root 357 dir 115392 index 86 namelen 19 name 2010-12-31-05:15:38 error 600
	unresolved ref root 358 dir 115392 index 86 namelen 19 name 2010-12-31-05:15:38 error 600
	unresolved ref root 359 dir 115392 index 86 namelen 19 name 2010-12-31-05:15:38 error 600
	unresolved ref root 360 dir 115392 index 86 namelen 19 name 2010-12-31-05:15:38 error 600
	unresolved ref root 361 dir 115392 index 86 namelen 19 name 2010-12-31-05:15:38 error 600
	unresolved ref root 362 dir 115392 index 86 namelen 19 name 2010-12-31-05:15:38 error 600
fs tree 355 refs 9 
	unresolved ref root 355 dir 115453 index 4 namelen 19 name 2011-01-01-05:15:41 error 600
	unresolved ref root 357 dir 115453 index 4 namelen 19 name 2011-01-01-05:15:41 error 600
	unresolved ref root 358 dir 115453 index 4 namelen 19 name 2011-01-01-05:15:41 error 600
	unresolved ref root 359 dir 115453 index 4 namelen 19 name 2011-01-01-05:15:41 error 600
	unresolved ref root 360 dir 115453 index 4 namelen 19 name 2011-01-01-05:15:41 error 600
	unresolved ref root 361 dir 115453 index 4 namelen 19 name 2011-01-01-05:15:41 error 600
	unresolved ref root 362 dir 115453 index 4 namelen 19 name 2011-01-01-05:15:41 error 600
	unresolved ref root 363 dir 115453 index 4 namelen 19 name 2011-01-01-05:15:41 error 600
fs tree 356 refs 7 not found
	unresolved ref root 357 dir 115392 index 87 namelen 19 name 2011-01-01-05:15:41 error 600
	unresolved ref root 358 dir 115392 index 87 namelen 19 name 2011-01-01-05:15:41 error 600
	unresolved ref root 359 dir 115392 index 87 namelen 19 name 2011-01-01-05:15:41 error 600
	unresolved ref root 360 dir 115392 index 87 namelen 19 name 2011-01-01-05:15:41 error 600
	unresolved ref root 361 dir 115392 index 87 namelen 19 name 2011-01-01-05:15:41 error 600
	unresolved ref root 362 dir 115392 index 87 namelen 19 name 2011-01-01-05:15:41 error 600
	unresolved ref root 363 dir 115392 index 87 namelen 19 name 2011-01-01-05:15:41 error 600
fs tree 357 refs 8 
	unresolved ref root 357 dir 115450 index 13 namelen 19 name 2011-01-02-05:15:29 error 600
	unresolved ref root 358 dir 115450 index 13 namelen 19 name 2011-01-02-05:15:29 error 600
	unresolved ref root 359 dir 115450 index 13 namelen 19 name 2011-01-02-05:15:29 error 600
	unresolved ref root 360 dir 115450 index 13 namelen 19 name 2011-01-02-05:15:29 error 600
	unresolved ref root 361 dir 115450 index 13 namelen 19 name 2011-01-02-05:15:29 error 600
	unresolved ref root 362 dir 115450 index 13 namelen 19 name 2011-01-02-05:15:29 error 600
	unresolved ref root 363 dir 115450 index 13 namelen 19 name 2011-01-02-05:15:29 error 600
fs tree 358 refs 7 
	unresolved ref root 358 dir 115392 index 88 namelen 19 name 2011-01-02-05:15:29 error 600
	unresolved ref root 359 dir 115392 index 88 namelen 19 name 2011-01-02-05:15:29 error 600
	unresolved ref root 360 dir 115392 index 88 namelen 19 name 2011-01-02-05:15:29 error 600
	unresolved ref root 361 dir 115392 index 88 namelen 19 name 2011-01-02-05:15:29 error 600
	unresolved ref root 362 dir 115392 index 88 namelen 19 name 2011-01-02-05:15:29 error 600
	unresolved ref root 363 dir 115392 index 88 namelen 19 name 2011-01-02-05:15:29 error 600
fs tree 359 refs 6 
	unresolved ref root 359 dir 115392 index 89 namelen 19 name 2011-01-03-05:16:11 error 600
	unresolved ref root 360 dir 115392 index 89 namelen 19 name 2011-01-03-05:16:11 error 600
	unresolved ref root 361 dir 115392 index 89 namelen 19 name 2011-01-03-05:16:11 error 600
	unresolved ref root 362 dir 115392 index 89 namelen 19 name 2011-01-03-05:16:11 error 600
	unresolved ref root 363 dir 115392 index 89 namelen 19 name 2011-01-03-05:16:11 error 600
fs tree 360 refs 5 
	unresolved ref root 360 dir 115392 index 90 namelen 19 name 2011-01-04-05:15:35 error 600
	unresolved ref root 361 dir 115392 index 90 namelen 19 name 2011-01-04-05:15:35 error 600
	unresolved ref root 362 dir 115392 index 90 namelen 19 name 2011-01-04-05:15:35 error 600
	unresolved ref root 363 dir 115392 index 90 namelen 19 name 2011-01-04-05:15:35 error 600
fs tree 361 refs 4 
	unresolved ref root 361 dir 115392 index 91 namelen 19 name 2011-01-05-05:18:40 error 600
	unresolved ref root 362 dir 115392 index 91 namelen 19 name 2011-01-05-05:18:40 error 600
	unresolved ref root 363 dir 115392 index 91 namelen 19 name 2011-01-05-05:18:40 error 600
fs tree 362 refs 3 
	unresolved ref root 362 dir 115392 index 92 namelen 19 name 2011-01-06-05:15:42 error 600
	unresolved ref root 363 dir 115392 index 92 namelen 19 name 2011-01-06-05:15:42 error 600
fs tree 363 refs 2 
	unresolved ref root 363 dir 115392 index 93 namelen 19 name 2011-01-07-05:15:25 error 600
found 1948176384 bytes used err is 1
total csum bytes: 1739600
total tree bytes: 166825984
total fs tree bytes: 150220800
btree space waste bytes: 43746814
file data blocks allocated: 7267450880
 referenced 5718896640
Btrfs Btrfs v0.19



-- 
Tomasz Chmielewski
http://wpkg.org
