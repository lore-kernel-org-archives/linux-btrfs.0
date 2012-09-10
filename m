Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54226 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab2IJQeG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Sep 2012 12:34:06 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1TB6w2-0004BS-3K
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2012 09:34:06 -0700
Date: Mon, 10 Sep 2012 09:34:06 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Symlink to a long filename "filename too long" error
Message-ID: <20120910163406.GG5053@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I got this error from rsync while trying to copy a device with a lot of hardlinks
to a btrfs volume:

Due to some filesystem corruption on my source device, I had a very long file as a symlink
target that btrfs wasn't able to recreate.
Mind you, in this case it's clearly not something I need, but is it
expected/known that ext4 can store longer filenames than btrfs?

-rw-r--r-- 1 root root    8192 Dec 12  1997 system.fvwm2rc95.gz
lrwxrwxrwx 1 root root    4095 Aug  2  2010 system.fvwmrc -> was scrubbed...\n"?"URL: %(url)s\n"?msgstr ""??#: Mailman/Handlers/Scrubber.py:129?msgid "no subject"?msgstr "??? ????"??#: Mailman/Handlers/Scrubber.py:130?msgid "no date"?msgstr ""??#: Mailman/Handlers/Scrubber.py:131?msgid "unknown sender"?msgstr ""??#: Mailman/Handlers/Scrubber.py:133?msgid ""?"An embedded message was scrubbed...\n"?"From: %(who)s\n"?"Subject: %(subject)s\n"?"Date: %(date)s\n"?"Size: %(size)s\n"?"Url: %(url)s\n"?msgstr ""??#: Mailman/Handlers/Scrubber.py:159?msgid ""?"A non-text attachment was scrubbed...\n"?"Name: %(filename)s\n"?"Type: %(ctype)s\n"?"Size: %(size)d bytes\n"?"Desc: %(desc)s\n"?"Url : %(url)s\n"?msgstr ""??#: Mailman/Handlers/ToDigest.py:140?msgid "%(realname)s Digest, Vol %(volume)d, Issue %(issue)d"?msgstr ""??#: Mailman/Handlers/ToDigest.py:178?msgid "digest header"?msgstr ""??#: Mailman/Handlers/ToDigest.py:181?msgid "Digest Header"?msgstr ""??#: Mailman/Handlers/ToDigest.py:194?msgid "Today's Topics:\n"?msgstr ""??#: Mailman/Handlers/ToDigest.py:261?msgid "Today's Topics (%(msgcount)d messages)"?msgstr ""??#: Mailman/Handlers/ToDigest.py:287?msgid "digest footer"?msgstr ""??#: Mailman/Handlers/ToDigest.py:290?msgid "Digest Footer"?msgstr ""??#: Mailman/Handlers/ToDigest.py:304?msgid "End of "?msgstr ""??#: Mailman/ListAdmin.py:279?msgid "Posting of your message titled \"%(subject)s\""?msgstr ""??#: Mailman/ListAdmin.py:299?msgid "Forward of moderated  message"?msgstr ""??#: Mailman/ListAdmin.py:356?msgid "New subscription request to list %(realname)s from %(addr)s"?msgstr ""??#: Mailman/ListAdmin.py:381?msgid "Subscription request"?msgstr ""??#: Mailman/ListAdmin.py:411?msgid "New unsubscription request from %(realname)s by %(addr)s"?msgstr ""??#: Mailman/ListAdmin.py:436?msgid "Unsubscription request"?msgstr ""??#: Mailman/ListAdmin.py:462?msgid "Original Message"?msgstr ""??#: Mailman/ListAdmin.py:465?msgid "Request to mailing list %(realname)s rejected"?msgstr ""??#: Mailman/MTA/Aliases.py:40?msgid ""?"To fi
nish creating your mailing list, you must edit your\n"?"/etc/aliases (or equivalent) file by adding the following lines:\n"?"\n"?"## %(listname)s mailing list\n"?"## created: %(date)s %(user)s\n"?"%(list)s \"|%(wrapper)s post %(listname)s\"\n"?"%(admin)s \"|%(wrapper)s mailowner %(listname)s\"\n"?"%(request)s \"|%(wrapper)s mailcmd %(listname)s\"\n"?"%(owner)s %(listname)s-admin\n"?msgstr ""??#: Mailman/MTA/Aliases.py:63?msgid ""?"To finish removing your mailing list, you must edit your\n"?"/etc/aliases (or equivalent) file by removing the following lines:\n"?"\n"?"%(list)s \"|%(wrapper)s post %(listname)s\"\n"?"%(admin)s \"|%(wrapper)s mailowner %(listname)s\"\n"?"%(request)s \"|%(wrapper)s mailcmd %(listname)s\"\n"?"%(owner)s %(listname)s-admin\n"?msgstr ""?"??? ????, ????? ????????? ??????? ???????? ?????? ????????\n"?"??? ?????????? ??????? ? ????? ????? /etc/aliases ????????? ??????:\n"?"\n"?"%(list)s \"|%(wrapper)s post %(listname)s\"\n"?"%(admin)s \"|%(wrapper)s mailowner %(listname)s\"\n"?"%(request)s \"|%(wrapper)s mailcmd %(listname)s\"\n"?"%(owner)s %(listname)s-admin\n"??#: Mailman/MTA/Manual.py:55?msgid ""?"The mailing list `%(listname)s' has been created via the through-the-web\n"?"interface.  In order to complete the activation of this mailing list, the\n"?"proper /etc/aliases (or equivalent) file must be updated.  The program\n"?"`newaliases' may also have to be run.\n"?"\n"?"Here are the entries for the /etc/aliases file:\n"?msgstr ""??#: Mailman/MTA/Manual.py:65?msgid ""?"\n"?"To finish creating your mailing list, you must edit your /etc/aliases (or\n"?"equivalent) file by adding the following lines, and possibly running the\n"?"`newaliases' program:\n"?"\n"?"## %(listname)s mailing list"?msgstr ""??#: Mailman/MTA/Manual.py:83?msgid "Mailing list creation request for list %(listname)s"?msgstr ""??#: Mailman/MTA/Manual.py:98?msgid ""?"The mailing list `%(listname)s' has been removed via the through-the-web\n"?"interface.  In order to complete the de-activation of this mailing list, "?"the\n"?"ap
propriate /etc/aliases (or equivalent) file must be updated.  
-rw-r--r-- 1 root root    6690 Nov 22  1997 system.steprc-menu.gz

Copy gave this error:
rsync: symlink "/mnt/dshelf3/backup/saroumane/20020317_oldload/usr/share/doc/menu/examples/system.fvwmrc" -> "was scrubbed...\n"\#012"URL: %(url)s\n"\#012msgstr ""\#012\#012#: Mailman/Handlers/Scrubber.py:129\#012msgid "no subject"\#012msgstr "\#302\#305\#332 \#324\#305\#315\#331"\#012\#012#: Mailman/Handlers/Scrubber.py:130\#012msgid "no date"\#012msgstr ""\#012\#012#: Mailman/Handlers/Scrubber.py:131\#012msgid "unknown sender"\#012msgstr ""\#012\#012#: Mailman/Handlers/Scrubber.py:133\#012msgid ""\#012"An embedded message was scrubbed...\n"\#012"From: %(who)s\n"\#012"Subject: %(subject)s\n"\#012"Date: %(date)s\n"\#012"Size: %(size)s\n"\#012"Url: %(url)s\n"\#012msgstr ""\#012\#012#: Mailman/Handlers/Scrubber.py
(...)
In order to complete the de-activation of this mailing list, "\#012"the\n"\#012"appropriate /etc/aliases (or equivalent) file must be updated.  " failed: File name too long (36)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
