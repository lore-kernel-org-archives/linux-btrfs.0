From: "kreijack@libero.it" <kreijack@libero.it>
Subject: [RFC] Removing a subvolume by an ordinary user
Date: Thu, 16 Sep 2010 13:47:33 +0200 (CEST)
Message-ID: <6546544.196961284637653794.JavaMail.defaultUser@defaultHost>
Reply-To: "kreijack@libero.it" <kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

currently BTRFS doesn't allow an ordinary user to remove a subvolume (o=
r=20
snapshot). I think that the reasons is simple: a subvolume may contain=20
files/directories owned by other user.
Allowing an ordinary user to remove a subvolume means allowing an ordin=
ary=20
user to remove filess/directories owned by other user. And this is not =
good.

Moreover BTRFS removes  a subvolume asynchronously, so it is not possib=
le to=20
return an error like =E2=80=9Chey you are trying to remove a not your f=
ile  ! Don=E2=80=99t do=20
it !=E2=80=9D.

My idea is to add another ioctl that permits to remove a subvolume only=
 when=20
it is empty and its host directory is writable by the user=E2=80=A6 lik=
e a directory.=20
An option is to allow to remove an empty subvolume  with the unlink(2) =
syscall:=20
no more tool is needed !=20
This will solve a lot of problem:
-	Consistently with the current unlink(2) behavior
-	The kernel has not to do complicate check
-	There no is necessity to add another interface to wait the releasing =
of the=20
space (see other thread reserving an IOCTL number; other details ).
The disadvantage is that it should be slower than the currently=20
implementation.
Of course I don=E2=80=99t want to remove the existing interface. I want=
 only to add=20
another one.

Comments ? Thoughts ?
Regards
G.Baroncelli=20

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
