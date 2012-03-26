From: Not Zippy <notzippy@gmail.com>
Subject: Re: btrfs: open_ctree failed
Date: Mon, 26 Mar 2012 14:40:24 -0700
Message-ID: <CANDob0+cBXnNH1dZ5socF7vaNoAB8wHACA4cN-w_1Z4T=VKUbA@mail.gmail.com>
References: <CANDob0+rwkLGeJg4kP+TpPpN8VOdrOV684F5YiLC6+BkzYehHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANDob0+rwkLGeJg4kP+TpPpN8VOdrOV684F5YiLC6+BkzYehHA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Was working this morning and my kernel crashed. Unfortunately one of
my two btrfs partitions would not mount after rebooting, this is the
error log:
[ 1518.147030] device label MediaNew devid 1 transid 28844 /dev/sdc3
[ 1518.147364] btrfs: enabling auto defrag
[ 1518.147372] btrfs: use lzo compression
[ 1518.632469] parent transid verify failed on 498530500608 wanted
26696 found 27535
[ 1518.632707] parent transid verify failed on 498530500608 wanted
26696 found 27535
[ 1518.640263] parent transid verify failed on 498530500608 wanted
26696 found 27535
[ 1518.640279] parent transid verify failed on 498530500608 wanted
26696 found 27535
[ 1518.660243] btrfs: open_ctree failed

Tried btrfsck after a lot of messages got:
...
leaf parent key incorrect 563096514560
Unable to find block group for 0
btrfsck: extent-tree.c:284: find_search_start: Assertion `!(1)' failed.

My kernel 3.0.0-16-generic, any hope for this ? Or is he dead jim ? I
don't have any snapshots of the partition.

Thoughts ?
thanks
