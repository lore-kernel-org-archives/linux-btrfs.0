From: Helmut Jarausch <jarausch@igpm.rwth-aachen.de>
Subject: How to fill a new created btrfs file system?
Date: Sat, 7 Jan 2012 17:59:13 +0000 (UTC)
Message-ID: <jea15h$789$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

using a 3.1.5 kernel (on Systemrescuecd) I cannot fill a newly created 
btrfs file system (mounted with -o compress) by extracting a (large) tar-
file. I always get LOTS of "no space left on device"!

Copying the same data again by extracting the tar-file once again, this 
seems to get fixed.

What can I do about it?
Has it been fixed with 3.2 ?
(Unfortunately, I don't have a rescue cd with a 3.2 kernel, yet)

Thanks for some hints,
Helmut.

-- 
Helmut Jarausch
Lehrstuhl fuer Numerische Mathematik
RWTH - Aachen University
D 52056 Aachen, Germany

