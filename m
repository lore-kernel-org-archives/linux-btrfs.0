From: Matteo Frigo <athena@fftw.org>
Subject: Re: Mass-Hardlinking Oops
Date: Tue, 13 Oct 2009 20:29:02 -0400
Message-ID: <87my3urf75.fsf@fftw.org>
References: <4A74401B.90801@mccme.ru> <20090803145741.GC3765@think> <4A76FB78.5000207@wpkg.org> <20090803235920.C13173@mccme.ru> <87my3y3r8u.fsf@faran.nsc.liu.se> <3d0408630910111543t23bdf6c3u2274efc65f0fe06c@mail.gmail.com> <4AD2E3CF.6080701@wpkg.org> <20091012124726.GL2632@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason@oracle.com> writes:

> Please keep in mind this is only a limit on the number of links to a
> single file where the links and the file are all in the same directory.

For the record, the nnmaildir mail backend in Gnus (an Emacs package
for reading news and email) creates multiple hardlinks to the same
file in the same directory.  I had several thousands hardlinks at one
time.

Gnus/nnmaildir uses hardlinks to keep track of attributes of email
messages.  For example, to denote that the email stored in file FOO
has been read, nnmaildir creates a link called marks/read/FOO, linking
to an empty file.  The rationale for this mechanism is that 1) you
don't want to modify the email message itself; 2) storing marks in
separate files allows concurrent accesses to the mail spool without
locking; and 3) using a hardlink rather than a new empty file saves an
inode.

I am not saying that what Gnus does is particularly smart, but this is
an example of a real world application that may break under btrfs.

Regards,
Matteo Frigo


