From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 5 May 2009 10:02:30 +0200
Message-ID: <20090505080230.GA16372@cip.informatik.uni-erlangen.de>
References: <20090428173251.GB7217@cip.informatik.uni-erlangen.de> <49F73FC9.3070607@partiallystapled.com> <49FEFBE6.40209@redhat.com> <49FEFE27.5090804@wpkg.org> <49FEFF9A.8060803@redhat.com> <20090504151518.GA13777@cip.informatik.uni-erlangen.de> <49FF11EE.2060404@redhat.com> <2a31deca0905040916s43b60cf3xdc56d365b5c1d233@mail.gmail.com> <20090504162421.GC13777@cip.informatik.uni-erlangen.de> <slrngvublr.95t.mykleb@janfrode.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Jan-Frode Myklebust <janfrode@tanso.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <slrngvublr.95t.mykleb@janfrode.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Jan,

* Jan-Frode Myklebust <janfrode@tanso.net> [090504 20:20]:
> "thin or shallow clones" sounds more like sparse images. I believe
> "linked clones" is the word for running multiple virtual machines off
> a single gold image. Ref, the "VMware View Composer" section of:

not exactly. VMware has one golden image and than accounts the blocks
different from the golden image by accounting the differences in a
snapshot file on a block level basis. So yes, it is a ,,sparse file''
but implemented in userland.

> "All desktops that are linked to a master image can be patched or upd=
ated
>  simply by updating the master image, without affecting users=E2=80=99=
 settings,
>  data or applications."

True for their desktops, because each desktop contains of a virtual
machine which is created when a user connects and destroyed, when he
disconnects. Bottom line the VM for the thin client only exists while
the user is connected. That of course makes it easy to update the maste=
r
image. But for VMs that are not desktops that are get created/destroyed
at least once a day, this doesn't scale.

        Thomas
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
