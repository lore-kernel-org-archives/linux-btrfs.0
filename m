From: Joe Peterson <lavajoe@gentoo.org>
Subject: Re: [PATCH] COW and checksumming ioctls
Date: Fri, 20 Jun 2008 23:59:03 -0600
Message-ID: <485C98A7.6090608@gentoo.org>
References: <1213921608.27507.152.camel@BVR-FS.beaverton.ibm.com> <485B3EC5.8090006@oracle.com> <485BB852.4060202@gentoo.org> <20080620135812.GB3224@unused.rdu.redhat.com> <485BC7AF.6020708@gentoo.org> <485C0899.1080203@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <485C0899.1080203@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

jim owens wrote:
> As I think someone already said (or hinted), a feature-lockout
> can be designed so the admnin can do that on some "set" for
> those who are paranoid.

That would be a nice feature.  Maybe even a mount option could be
available to "disable the disabling" of checksumming/COW for cases in
which the admin decides users should not be changing these attributes
for a particular filesystem.

> Again for those who are paranoid, making these auditable events
> (I'm probably not using the right linux term) solves the need
> to know something like checksum-off has occured.

Yes, that reminds me of ZFS's logging facility, in which case an admin
can check to see all operations ever done to the filesystem.  When
someone is managing a bunch of computers and/or filesystems (making it
easy to get forgetful), it is always nice to be able to go back and ask
the system what admin options were used as a sanity check.  I think
that's a cool idea.

						-Joe
