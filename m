From: Joe Peterson <lavajoe@gentoo.org>
Subject: Re: [PATCH] COW and checksumming ioctls
Date: Fri, 20 Jun 2008 09:07:27 -0600
Message-ID: <485BC7AF.6020708@gentoo.org>
References: <1213921608.27507.152.camel@BVR-FS.beaverton.ibm.com> <485B3EC5.8090006@oracle.com> <485BB852.4060202@gentoo.org> <20080620135812.GB3224@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Zach Brown <zach.brown@oracle.com>, Mingming <cmm@us.ibm.com>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080620135812.GB3224@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote:
> Database apps that do their own complicated stuff to make sure everything makes
> it to the disk properly who dont want the extra overhead of checksumming.

I do see the benefit of that, if indeed the DB does end-to-end checking.
 Then again, I could almost see that perhaps making the setting based on
something at the subvolume level (not per-file level) might be even
better for that case.

> What if somebody logs in as root and does an rm -rf?  I'm not thinking that
> running the command to disable checksumming on a file will be something that
> gets run often by accident, but even if it does the mantra of linux in general
> has never been "dont let users do something because some idiot could screw it
> all up."

Sure, that's true.  I am not saying that we need to protect users from
themselves, as long as there is a way to clearly see what the settings
are (so a user/admin can verify the state, e.g.).  I guess my main
concern would be if it is relatively easy for this to go completely
unnoticed.  Also, would it be only root who could change such a setting?

> I don't really understand the above objection.  Checksumming doesn't make
> everything magically protected, just makes it easier to catch when problems are
> happening.  I don't see how having it off then turning it on would cause any
> sorts of issues.

Well, with checksumming on, there is continuous protection.  And what I
mean by "protection" is peace-of-mind that the data integrity has been
checked (I don't necessarily mean protected from loss).  For me,
*knowing* that the data is bad is the most important thing, so it does
not silently propagate to backups, etc.

So, if a file, say, is "protected" by checksumming as it gets read,
changed, etc., there is a continuity of protection, and the user can
have confidence that the data read is the same as the data written.

On the other hand, if one turns off checksumming, there is then a break
in that continuity, so any further reads or writes will not be be
checked.  Even if the file is not written while not having checksumming
enabled, but then it is re-enabled, now there is no way to know that the
file's contents are the same as what they were before checksumming was
turned off - that confidence is lost.

						-Joe
