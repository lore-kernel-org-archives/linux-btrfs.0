From: jim owens <jowens@hp.com>
Subject: Re: metadata copied/data not copied?
Date: Mon, 16 Mar 2009 11:28:03 -0400
Message-ID: <49BE7003.2050404@hp.com>
References: <200903161035.19446.csights@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: CSights <csights@fastmail.fm>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200903161035.19446.csights@fastmail.fm>
List-ID: <linux-btrfs.vger.kernel.org>

CSights wrote:
> Hi everyone,
> 	I'm curious what would happen in btrfs if the following commands were issued:
> 
> # cp file1 file2
> # chown newuser:newgroup file2
> 
> Where file1 was owned by olduser:oldgroup.
> 
> 
> 	If I understand copy-on-write correctly the "cp" would merely create a new 
> pointer (or whatever it is called :( ) containing the files' metadata but the 
> file contents would not actually be duplicated.

NO.  The concept you describe requires "deduplicate".

What you are forgetting is that "cp" is a user-space program that
reads data and writes it to a new file.  The kernel does not see
this as a Copy.

jim
