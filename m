Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:44844 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933388Ab3JOR2q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 13:28:46 -0400
Received: by mail-bk0-f54.google.com with SMTP id mz12so3379812bkb.27
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2013 10:28:44 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAN3gubk5xUxBzjZdknNc3j=at-z22t52ii+_aMBvLsk2RL1t_w@mail.gmail.com>
References: <CAN3gubk5xUxBzjZdknNc3j=at-z22t52ii+_aMBvLsk2RL1t_w@mail.gmail.com>
Date: Tue, 15 Oct 2013 18:28:44 +0100
Message-ID: <CAL3q7H5OC2Z-aak8kEDBQoXRrd33gVusT-9D5C6+-CXD73gs4w@mail.gmail.com>
Subject: Re: ACL rules doesn't propagate on btrfs
From: Filipe David Manana <fdmanana@gmail.com>
To: Giuseppe Fierro <giuseppe@fierro.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 15, 2013 at 4:56 PM, Giuseppe Fierro <giuseppe@fierro.org> wrote:
> I'm playing with acl permission on btrfs (my favourite filesytem).
> When I set ACL permission on directory happens that this permission doesn't
> propagate inside the directory structure.
>
> As you can see from the following example after the second level the ACL's
> rules are completely forgotten.
>
>
> gspe@Jura:~/Videos$ sudo mkdir test_prj
>> [sudo] password for gspe:
>> gspe@Jura:~/Videos$ ls -l
>> total 0
>> drwxr-xr-x 1 root root 0 ott 15 17:48 test_prj
>> gspe@Jura:~/Videos$ sudo chown root:gmingegneria test_prj
>> gspe@Jura:~/Videos$ ls -l
>> total 0
>> drwxr-xr-x 1 root gmingegneria 0 ott 15 17:48 test_prj
>> gspe@Jura:~/Videos$ sudo chmod o-rwx test_prj
>> gspe@Jura:~/Videos$ sudo chmod g+rwx test_prj
>> gspe@Jura:~/Videos$ ls -l
>> total 0
>> drwxrwx--- 1 root gmingegneria 0 ott 15 17:48 test_prj
>> gspe@Jura:~/Videos$ sudo chmod g+s test_prj
>> gspe@Jura:~/Videos$ ls -l
>> total 0
>> drwxrws--- 1 root gmingegneria 0 ott 15 17:48 test_prj
>> gspe@Jura:~/Videos$ sudo setfacl -d --set u::rwx,g::rwx,o::- test_prj
>> gspe@Jura:~/Videos$ ls -l
>> total 0
>> drwxrws---+ 1 root gmingegneria 0 ott 15 17:48 test_prj
>> gspe@Jura:~/Videos$ getfacl test_prj
>> # file: test_prj
>> # owner: root
>> # group: gmingegneria
>> # flags: -s-
>> user::rwx
>> group::rwx
>> other::---
>> default:user::rwx
>> default:group::rwx
>> default:other::---
>> gspe@Jura:~/Videos$ cd test_prj
>> gspe@Jura:~/Videos/test_prj$ touch file01
>> gspe@Jura:~/Videos/test_prj$ mkdir test01
>> gspe@Jura:~/Videos/test_prj$ ls -l
>> total 0
>> -rw-rw---- 1 gspe gmingegneria 0 ott 15 17:51 file01
>> drwxrws--- 1 gspe gmingegneria 0 ott 15 17:51 test01
>> gspe@Jura:~/Videos/test_prj$ getfacl file01
>> # file: file01
>> # owner: gspe
>> # group: gmingegneria
>> user::rw-
>> group::rw-
>> other::---
>> gspe@Jura:~/Videos/test_prj$ getfacl test01
>> # file: test01
>> # owner: gspe
>> # group: gmingegneria
>> # flags: -s-
>> user::rwx
>> group::rwx
>> other::---
>> gspe@Jura:~/Videos/test_prj$ cd test01

Confirmed here with btrfs-next and found out why it happens. If you
unmount and mount again the fs, getfacl returns the expected output.
Sending a patch soon.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
