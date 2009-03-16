From: CSights <csights@fastmail.fm>
Subject: metadata copied/data not copied?
Date: Mon, 16 Mar 2009 10:35:19 -0400
Message-ID: <200903161035.19446.csights@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,
	I'm curious what would happen in btrfs if the following commands were issued:

# cp file1 file2
# chown newuser:newgroup file2

Where file1 was owned by olduser:oldgroup.


	If I understand copy-on-write correctly the "cp" would merely create a new 
pointer (or whatever it is called :( ) containing the files' metadata but the 
file contents would not actually be duplicated.
	Then the "chown" would change the metadata so that file2's metadata indicates 
newuser:newgroup owned the file contents.  At the same time the metadata of 
file1 would say that olduser:oldgroup owned the file contents.
	
	(If a user modified the file contents, the contents would be copied at that 
time.)

Thanks, curious newbie,
	C.
