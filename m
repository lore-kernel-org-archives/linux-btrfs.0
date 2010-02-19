From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Which volume? no space left, need 4096, 274432 delalloc bytes,
	8360148992 bytes_used, 4096 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly,
	0 may use 8360427520 total
Date: Fri, 19 Feb 2010 15:47:20 -0800
Message-ID: <93cdabd21002191547i3a0085abmf68f66a7b17d991f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If I had more than one btrfs volume, how would I know which volume
caused these errors?  Sure I can look at df and btrfs-show, but
shouldn't these messages say definitively?

Feb 19 04:31:26 dt01 kernel: no space left, need 4096, 274432 delalloc
bytes, 8360148992 bytes_used, 4096 bytes_reserved, 0 bytes_pinned, 0
bytes_readonly, 0 may use 8360427520 total
Feb 19 04:34:02 dt01 kernel: no space left, need 4096, 270336 delalloc
bytes, 8360153088 bytes_used, 4096 bytes_reserved, 0 bytes_pinned, 0
bytes_readonly, 0 may use 8360427520 total
Feb 19 04:43:18 dt01 kernel: no space left, need 270336, 36864
delalloc bytes, 8360140800 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 04:44:03 dt01 kernel: no space left, need 270336, 49152
delalloc bytes, 8360165376 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 04:44:09 dt01 kernel: device fsid
5e44906058064a32-b179f2f9b4e606a9 devid 1 transid 7 /dev/sda7
Feb 19 04:46:18 dt01 kernel: no space left, need 270336, 77824
delalloc bytes, 8360275968 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 04:47:03 dt01 kernel: no space left, need 270336, 102400
delalloc bytes, 8360300544 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 04:52:18 dt01 kernel: no space left, need 270336, 65536
delalloc bytes, 8360214528 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 04:53:03 dt01 kernel: no space left, need 270336, 36864
delalloc bytes, 8360280064 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 04:53:48 dt01 kernel: no space left, need 270336, 32768
delalloc bytes, 8360329216 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 05:27:48 dt01 kernel: no space left, need 270336, 36864
delalloc bytes, 8360140800 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 05:27:58 dt01 kernel: device fsid
5945de3116704a8a-11f3234550356c85 devid 1 transid 7 /dev/sda7
Feb 19 05:30:34 dt01 kernel: no space left, need 270336, 53248
delalloc bytes, 8360284160 bytes_used, 12288 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 05:40:18 dt01 kernel: no space left, need 270336, 32768
delalloc bytes, 8360378368 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 06:06:33 dt01 kernel: no space left, need 270336, 28672
delalloc bytes, 8360153088 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 06:07:18 dt01 kernel: no space left, need 270336, 53248
delalloc bytes, 8360169472 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 06:08:03 dt01 kernel: no space left, need 270336, 65536
delalloc bytes, 8360206336 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 06:14:03 dt01 kernel: no space left, need 270336, 69632
delalloc bytes, 8360251392 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 06:14:30 dt01 kernel: no space left, need 270336, 94208
delalloc bytes, 8360251392 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 06:14:42 dt01 kernel: no space left, need 94208, 24576 delalloc
bytes, 8360325120 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0
bytes_readonly, 0 may use 8360427520 total
Feb 19 06:15:35 dt01 kernel: no space left, need 270336, 57344
delalloc bytes, 8360349696 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 06:40:19 dt01 kernel: no space left, need 270336, 49152
delalloc bytes, 8360202240 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 06:41:49 dt01 kernel: no space left, need 270336, 65536
delalloc bytes, 8360271872 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 06:42:12 dt01 kernel: no space left, need 94208, 98304 delalloc
bytes, 8360271872 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0
bytes_readonly, 0 may use 8360427520 total
Feb 19 06:42:33 dt01 kernel: no space left, need 270336, 86016
delalloc bytes, 8360292352 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 06:44:03 dt01 kernel: no space left, need 270336, 73728
delalloc bytes, 8360341504 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 06:47:48 dt01 kernel: no space left, need 270336, 24576
delalloc bytes, 8360312832 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 06:48:25 dt01 kernel: no space left, need 270336, 45056
delalloc bytes, 8360333312 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 06:48:33 dt01 kernel: no space left, need 270336, 57344
delalloc bytes, 8360333312 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 07:14:03 dt01 kernel: no space left, need 270336, 36864
delalloc bytes, 8360185856 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 07:14:26 dt01 kernel: no space left, need 270336, 40960
delalloc bytes, 8360206336 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 07:15:33 dt01 kernel: no space left, need 270336, 65536
delalloc bytes, 8360247296 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 07:16:18 dt01 kernel: no space left, need 270336, 53248
delalloc bytes, 8360284160 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 07:16:47 dt01 kernel: no space left, need 270336, 53248
delalloc bytes, 8360312832 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 07:17:00 dt01 kernel: no space left, need 270336, 61440
delalloc bytes, 8360321024 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 07:17:48 dt01 kernel: no space left, need 270336, 57344
delalloc bytes, 8360357888 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 07:25:42 dt01 kernel: no space left, need 94208, 49152 delalloc
bytes, 8360357888 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0
bytes_readonly, 0 may use 8360427520 total
Feb 19 07:47:40 dt01 kernel: no space left, need 270336, 45056
delalloc bytes, 8360177664 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 07:47:48 dt01 kernel: no space left, need 270336, 40960
delalloc bytes, 8360185856 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 07:49:18 dt01 kernel: no space left, need 270336, 69632
delalloc bytes, 8360247296 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 07:50:04 dt01 kernel: no space left, need 270336, 81920
delalloc bytes, 8360271872 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 07:50:48 dt01 kernel: no space left, need 270336, 57344
delalloc bytes, 8360312832 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 07:51:33 dt01 kernel: no space left, need 270336, 81920
delalloc bytes, 8360333312 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 07:58:18 dt01 kernel: no space left, need 270336, 28672
delalloc bytes, 8360353792 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 07:59:03 dt01 kernel: no space left, need 270336, 49152
delalloc bytes, 8360374272 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 08:23:03 dt01 kernel: no space left, need 270336, 32768
delalloc bytes, 8360198144 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 08:23:48 dt01 kernel: no space left, need 270336, 49152
delalloc bytes, 8360226816 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 08:25:45 dt01 kernel: no space left, need 270336, 53248
delalloc bytes, 8360321024 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 08:26:03 dt01 kernel: no space left, need 270336, 69632
delalloc bytes, 8360333312 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 08:26:06 dt01 kernel: no space left, need 32768, 86016 delalloc
bytes, 8360333312 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0
bytes_readonly, 0 may use 8360427520 total
Feb 19 08:31:04 dt01 kernel: no space left, need 606208, 217088
delalloc bytes, 8359723008 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 08:31:04 dt01 kernel: no space left, need 1318912, 405504
delalloc bytes, 8359723008 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 08:31:04 dt01 kernel: no space left, need 1744896, 212992
delalloc bytes, 8359763968 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 08:31:06 dt01 kernel: no space left, need 786432, 303104
delalloc bytes, 8359788544 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
Feb 19 08:31:07 dt01 kernel: no space left, need 28672, 602112
delalloc bytes, 8359800832 bytes_used, 0 bytes_reserved, 0
bytes_pinned, 0 bytes_readonly, 0 may use 8360427520 total
