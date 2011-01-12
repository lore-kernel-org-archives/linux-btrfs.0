From: =?iso-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Subject: Question regarding transaction end/commit
Date: Wed, 12 Jan 2011 02:08:12 +0000
Message-ID: <C98E06B8-846B-44C8-8A40-AA147D4E052E@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

I've been struggling to understand when to use 'btrfs_end_transaction()=
' instead of 'btrfs_commit_transaction()', and vice-versa.

My doubts arise due to use of both of them in different points of the c=
ode, and some times a given method may even chose to do one instead of =
the other based on different conditions.

Is there any rule of thumbs that may be used to chose between them, or =
any piece of information lying around that may give me some more insigh=
t on this matter?

Cheers.

---
Jo=E3o Eduardo Lu=EDs




--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
