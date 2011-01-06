From: Alan Chandler <alan.chandler@hartley-consultants.com>
Subject: Raid1 degraded mode
Date: Thu, 06 Jan 2011 16:41:53 +0000
Message-ID: <4D25F0D1.1030009@hartley-consultants.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020300090202060003070208"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020300090202060003070208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I am trying to understand how btrfs works with Raid1.

Is it possible to create the filesystem with -m raid1 -d raid1 in which 
there is only one device available when the filesystem is created.  Is 
it possible to refer to a second device as "missing"

The use case I am thinking of is converting an existing raid1 setup from 
mdm + lvm + ext4 to btrfs with raid1 and subvolumes.

I would like to fail half of my existing mdm devices and re-initialise 
them as btrfs.  make subvolumes for each of my lvm logical volumes, copy 
the data over, then remove mdm and lvm entirely and add back in the 
devices that were supporting them as additional btrfs devices.

The problem I see is that, according to the wiki, specifying -m raid1 
and -d raid1 with a single device causes two copies to be made on the 
same device, whereas I really want it to start off degraded with only 
one copy until I add in the second device.  Trying to cram two copies on 
the one device will make it run out of space.



--------------020300090202060003070208
Content-Type: text/x-vcard; charset=utf-8;
 name="alan_chandler.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="alan_chandler.vcf"

begin:vcard
fn:Alan Chandler
n:Chandler;Alan
email;internet:alan.chandler@hartley-consultants.com
tel;cell:+44 7540 419 854
version:2.1
end:vcard


--------------020300090202060003070208--
