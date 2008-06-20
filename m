From: jim owens <jowens@hp.com>
Subject: Re: [PATCH] COW and checksumming ioctls
Date: Fri, 20 Jun 2008 15:44:25 -0400
Message-ID: <485C0899.1080203@hp.com>
References: <1213921608.27507.152.camel@BVR-FS.beaverton.ibm.com> <485B3EC5.8090006@oracle.com> <485BB852.4060202@gentoo.org> <20080620135812.GB3224@unused.rdu.redhat.com> <485BC7AF.6020708@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Joe Peterson <lavajoe@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <485BC7AF.6020708@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

Joe Peterson wrote:

>  Then again, I could almost see that perhaps making the setting based on
> something at the subvolume level (not per-file level) might be even
> better for that case. 
...
> Sure, that's true.  I am not saying that we need to protect users from
> themselves, as long as there is a way to clearly see what the settings
> are (so a user/admin can verify the state, e.g.).  I guess my main
> concern would be if it is relatively easy for this to go completely
> unnoticed.  Also, would it be only root who could change such a setting?

It is important to have the per-file granularity.  I agree with
you that being able to apply this to "all members of this set",
where the "set" is whatever is practical for btrfs is a nice
ease-of-use feature.

The ability to do the change is probably based on "right to
change file attributes", which depends on security policy,
but it should not be designed as a root-only restriction.

As I think someone already said (or hinted), a feature-lockout
can be designed so the admnin can do that on some "set" for
those who are paranoid.

Again for those who are paranoid, making these auditable events
(I'm probably not using the right linux term) solves the need
to know something like checksum-off has occured.

jim
