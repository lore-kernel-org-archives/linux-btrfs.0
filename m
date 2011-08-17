From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: snapshot ctime // Re: [RFC] btrfs auto snapshot
Date: Wed, 17 Aug 2011 11:56:08 -0400
Message-ID: <CALJXSJpVWHZEKp9uZ8SB-mdkr2U8kdU=-k1=2U3QsoWXsTHC2Q@mail.gmail.com>
References: <4E4B2452.9070407@oracle.com> <20110817140433.GA32261@hendrix.borisch.local>
 <20110817211316.0414bb5a@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dave <dave@thekilempire.com>, Anand Jain <Anand.Jain@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110817211316.0414bb5a@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 17, 2011 at 11:13 AM, Roman Mamedov <rm@romanrm.ru> wrote:
> So until someone cares about snapshot ctime enough to fix this, btrfs will not be a convenient FS to work with timed snapshotting/cleanup.

Isn't the ctime the creation date of the original folder?
