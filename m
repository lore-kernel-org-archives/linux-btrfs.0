From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
Subject: Re: bug#8001: cp (8.10) sparse handling fails on compressed btrfs
 (cp/fiemap-2)
Date: Wed, 23 Feb 2011 09:49:55 +0000
Message-ID: <4D64D843.9080903@draigBrady.com>
References: <201102072253.34476.vapier@gentoo.org> <4D52730A.2080008@draigBrady.com> <201102191328.42067.vapier@gentoo.org> <4D6050A7.5090407@draigBrady.com> <AANLkTi=4x+RzqZRKVCreWy67eOUSocjA4c_N+9aEHeG9@mail.gmail.com> <1298431849-sup-5365@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Mike Frysinger <vapier@gentoo.org>,
	BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>, 8001-done@debbugs.gnu.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1298431849-sup-5365@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 23/02/11 03:31, Chris Mason wrote:
> I've got a fix for this on the btrfs side in testing.  It is definite=
ly
> a btrfs bug.

[resend]

Cool.
I'm closing this ticket, so.

Interesting I didn't notice this with kernel-2.6.38-0.rc4.git0.2.fc15.i=
686
(with a 1G loop back BTRFS on ext4)

I'd appreciate a link to the fix at some stage.
If we know what's going on exactly we might be
able to know how widespread the issue is and
whether we could work around it in `cp`.

cheers,
P=C3=A1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
