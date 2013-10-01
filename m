Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:44512 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751361Ab3JAVUI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 17:20:08 -0400
Date: Tue, 1 Oct 2013 15:12:55 -0600
From: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
To: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Is `btrfsck --repair` supposed to actually repair problems?
Message-ID: <20131001211255.GA5946@pyropus.ca>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I've been using btrfs for bulk-storage purposes for a couple of years now (on
vanilla linux-stable kernels on a few machines).  I recently set up a new
filesystem and have been copying data to it, when I had an unrelated kernel
lockup.  As expected, after rebooting btrfsck reported some checksum verify
errors like:

checksum verify failed on 806795800576 found 01A8A8FB wanted 51361541
checksum verify failed on 806795800576 found 01A8A8FB wanted 51361541
checksum verify failed on 846990413824 found FB9C4BDC wanted AA2E389E

There's a few dozen of these.

Running btrfsck with the --repair option, however, does not appear to fix
these problems.  I'll attach the complete output of running with the --repair
option; running btrfsck in check-only mode afterwards reports largely the same
checksum errors as it did originally, prior to "repair".

Shouldn't `btrfsck --repair` actually repair these errors?  Am I doing
something wrong?

System details:
  -current kernel is linux-stable 3.9.11 x86_64
  -btrfs-progs built from
    git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git, which
    doesn't appear to have changed in a long time
  -filesystem is 16.4TiB btrfs on LVM on md_crypt on an mdadm RAID-6 array.
  I know this is perhaps an odd setup, but btrfs didn't support RAID-6 when I 
  started using it.

Any advice appreciated.  Thanks,

Charles

-- 
-----------------------------------------------------------------------
Charles Cazabon
GPL'ed software available at:               http://pyropus.ca/software/
-----------------------------------------------------------------------
--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="btrfsck-repair.log"

# btrfsck --repair /dev/extbackup/bigbackup
enabling repair mode
Checking filesystem on /dev/extbackup/bigbackup
UUID: c18dfd04-d931-4269-b999-e94df3b1918c
checking extents
checksum verify failed on 78318182400 found 66D5FD23 wanted 5FFBFE3B
checksum verify failed on 78318182400 found 66D5FD23 wanted 5FFBFE3B
checksum verify failed on 530263736320 found 71FB90AF wanted 150EBA1C
checksum verify failed on 530263736320 found 71FB90AF wanted 150EBA1C
checksum verify failed on 669649289216 found ED6068EA wanted CE438B87
checksum verify failed on 669649289216 found ED6068EA wanted CE438B87
checksum verify failed on 806659584000 found E813828C wanted ED236710
checksum verify failed on 806659584000 found E813828C wanted ED236710
checksum verify failed on 806795800576 found 01A8A8FB wanted 51361541
checksum verify failed on 806795800576 found 01A8A8FB wanted 51361541
checksum verify failed on 846990413824 found FB9C4BDC wanted AA2E389E
checksum verify failed on 846990413824 found FB9C4BDC wanted AA2E389E
checksum verify failed on 854909063168 found 51E74B28 wanted D49BBFC6
checksum verify failed on 854909063168 found 51E74B28 wanted D49BBFC6
checksum verify failed on 855239913472 found 06557D7A wanted ED2CC52C
checksum verify failed on 855239913472 found 06557D7A wanted ED2CC52C
checksum verify failed on 881561030656 found 47735BC0 wanted F8957A7C
checksum verify failed on 881561030656 found 47735BC0 wanted F8957A7C
checksum verify failed on 919416066048 found B884B190 wanted 13DD9265
checksum verify failed on 919416066048 found B884B190 wanted 13DD9265
checksum verify failed on 984444981248 found 383F144D wanted 0801F812
checksum verify failed on 984444981248 found 383F144D wanted 0801F812
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checksum verify failed on 78318182400 found 66D5FD23 wanted 5FFBFE3B
checksum verify failed on 78318182400 found 66D5FD23 wanted 5FFBFE3B
checksum verify failed on 530263736320 found 71FB90AF wanted 150EBA1C
checksum verify failed on 530263736320 found 71FB90AF wanted 150EBA1C
checksum verify failed on 669649289216 found ED6068EA wanted CE438B87
checksum verify failed on 669649289216 found ED6068EA wanted CE438B87
checksum verify failed on 806659584000 found E813828C wanted ED236710
checksum verify failed on 806659584000 found E813828C wanted ED236710
checksum verify failed on 806795800576 found 01A8A8FB wanted 51361541
checksum verify failed on 806795800576 found 01A8A8FB wanted 51361541
checksum verify failed on 846990413824 found FB9C4BDC wanted AA2E389E
checksum verify failed on 846990413824 found FB9C4BDC wanted AA2E389E
checksum verify failed on 854909063168 found 51E74B28 wanted D49BBFC6
checksum verify failed on 854909063168 found 51E74B28 wanted D49BBFC6
checksum verify failed on 855239913472 found 06557D7A wanted ED2CC52C
checksum verify failed on 855239913472 found 06557D7A wanted ED2CC52C
checksum verify failed on 881561030656 found 47735BC0 wanted F8957A7C
checksum verify failed on 881561030656 found 47735BC0 wanted F8957A7C
checksum verify failed on 919416066048 found B884B190 wanted 13DD9265
checksum verify failed on 919416066048 found B884B190 wanted 13DD9265
checksum verify failed on 984444981248 found 383F144D wanted 0801F812
checksum verify failed on 984444981248 found 383F144D wanted 0801F812
checking csums
checksum verify failed on 78318182400 found 66D5FD23 wanted 5FFBFE3B
checksum verify failed on 78318182400 found 66D5FD23 wanted 5FFBFE3B
checksum verify failed on 530263736320 found 71FB90AF wanted 150EBA1C
checksum verify failed on 530263736320 found 71FB90AF wanted 150EBA1C
checking root refs
found 530436962463 bytes used err is 0
total csum bytes: 4526618444
total tree bytes: 18394226688
total fs tree bytes: 11872870400
total extent tree bytes: 618696704
btree space waste bytes: 3766887803
file data blocks allocated: 4636473634816
 referenced 4636473634816
Btrfs v0.20-rc1-358-g194aa4a-dirty


--+QahgC5+KEYLbs62--
