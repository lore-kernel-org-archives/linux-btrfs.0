From: Martin <m_btrfs@ml1.co.uk>
Subject: btrfs across a mix of SSDs & HDDs
Date: Tue, 01 May 2012 20:35:41 +0100
Message-ID: <jnpdud$ta9$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

How well does btrfs perform across a mix of:

1 SSD and 1 HDD for 'raid' 1 mirror for both data and metadata?

Similarly so across 2 SSDs and 2 HDDs (4 devices)?

Can multiple (small) SSDs be 'clustered' as one device and then mirrored
with one large HDD with btrfs directly? (Other than using lvm...)


The idea is to gain the random access speed of the SSDs but have the
HDDs as backup in case the SSDs fail due to wear...

The usage is to support a few hundred Maildirs + imap for users that
often have many thousands of emails in the one folder for their inbox...


(And no, the users cannot be trained to clean out their inboxes or to be
more hierarchically tidy... :-( )

Or is btrfs yet too premature to suffer such use?


Regards,
Martin


