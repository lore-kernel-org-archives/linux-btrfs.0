From: Michel Alexandre Salim <salimma@fedoraproject.org>
Subject: Odd rebalancing behavior
Date: Mon, 04 Apr 2011 12:14:33 +0200
Message-ID: <4D999A09.3030008@fedoraproject.org>
Reply-To: For testing and quality assurance of Fedora releases
	<test@lists.fedoraproject.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: linux-btrfs@vger.kernel.org, kernel@lists.fedoraproject.org,
	test@lists.fedoraproject.org
Return-path: <test-bounces@lists.fedoraproject.org>
List-Unsubscribe: <https://admin.fedoraproject.org/mailman/listinfo/test>,
	<mailto:test-request@lists.fedoraproject.org?subject=unsubscribe>
List-Archive: <http://lists.fedoraproject.org/pipermail/test>
List-Post: <mailto:test@lists.fedoraproject.org>
List-Help: <mailto:test-request@lists.fedoraproject.org?subject=help>
List-Subscribe: <https://admin.fedoraproject.org/mailman/listinfo/test>,
	<mailto:test-request@lists.fedoraproject.org?subject=subscribe>
Errors-To: test-bounces@lists.fedoraproject.org
List-ID: <linux-btrfs.vger.kernel.org>

I have an external 4-disk enclosure, connected through USB 2.0 (my
laptop does not have a USB 3.0 connector, and the eSATA connector
somehow does not work); it initially had a 2-disk btrfs soft-RAID1 file
system (both data and metadata are RAID1).

I recently added two more disks and did a rebalance. To my surprise it
went past the point where all four disks have the same amount of disk
usage, and went all the way to the original disks being empty, and the
new disks having all the data!

Label: 'media.store'  uuid: 4cfd3551-aa85-4399-b872-9238ddb14c97
	Total devices 4 FS bytes used 1.22TB
	devid    3 size 1.82TB used 1.24TB path /dev/sdb
	devid    4 size 1.82TB used 1.24TB path /dev/sdc
	devid    2 size 1.82TB used 8.00MB path /dev/sde
	devid    1 size 1.82TB used 12.00MB path /dev/sdd

Is this to be expected? Would another rebalance fix it, or should I
force-stop it by shutting down when the disk usage is roughly balanced?

This is on Fedora 15 pre-release, x86_64, fully updated, kernel
2.6.38.2-9 and btrfs-progs 0.19-13

Thanks,

-- 
Michel Alexandre Salim
GPG key ID: 78884778

()  ascii ribbon campaign - against html e-mail
/\  www.asciiribbon.org   - against proprietary attachments
-- 
test mailing list
test@lists.fedoraproject.org
To unsubscribe: 
https://admin.fedoraproject.org/mailman/listinfo/test
