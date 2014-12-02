Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39193 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbaLBAec (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 19:34:32 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvbQD-0001hG-Eq
	for linux-btrfs@vger.kernel.org; Tue, 02 Dec 2014 01:34:29 +0100
Received: from 50.245.141.77 ([50.245.141.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 01:34:29 +0100
Received: from eternaleye by 50.245.141.77 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 01:34:29 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Mon, 01 Dec 2014 16:34:16 -0800
Message-ID: <m5j1e8$5jk$1@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <20141125163905.GJ26471@twin.jikos.cz> <m5dash$58v$1@ger.gmane.org> <CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com> <m5dcia$tk8$1@ger.gmane.org> <CAJBj3ve8rfdAVLNwQ0ZxD8nQ3+5TwtTYXZ6BOMK0NquzHK15WA@mail.gmail.com> <547C618C.8020201@gmail.com> <CAJBj3vfvBd5robRak1j-q0qGVT46BTR6VM=SRg5S-2p8GxjX6A@mail.gmail.com> <547CA870.9040904@gmail.com> <CAJBj3vekJ6B45SnbL_TSuCm6Z-YOX-B1XNPxUuJgu4Cy2b3y-A@mail.gmail.com> <m5ifgo$c1e$1@ger.gmane.org> <CAJBj3veLYPPhsiX12BdSerJwP4izsb4d-=HN91CnSm-+vKE5Tw@mail.gmail.com> <m5ihkj$cep$1@ger.gmane.org> <m5ihs4$cep$2@ger.gmane.org> <CAJBj3venQGosBDUrKicGK1qgymBEBF=VWSiJjQiPpnis+Rrhpg@mail.gmail.com> <m5is7h$peq$1@ger.gmane.org> <CAJBj3vfnvtcb8NTQ2k4eg43oEtOx9YT4SFZ6wfOjC=fvSrHmow@mail.gmail.com> <m5iukq$s45$2@ger.gmane.org> <CAJBj3vc_rRoXT-qhu6ji3qPG_u=Piu6XSUzXRhbJ_FeGHB4jcg@mail.gmail.com> <m5j0aq$g6r$3@ger.gmane.org> <CAJBj3vd83Vgfxsfitbz0vVma-jPWb22nj=PC-kigxnipV=BrKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Williams wrote:

> On Mon, Dec 1, 2014 at 4:15 PM, Alex Elsayed <eternaleye@gmail.com> wrote:
>> There's a thing called the transitive property. When CRC32 is faster than
>> SpookyHash and CityHash (while admittedly weaker), and SHA-1 on SPARC is
>> faster than CRC32, there are comparisons that can be made.
> 
> And yet you applied the transitive property with poor assumptions and
> in a convoluted way to come up with an incorrect conclusion.
> 
> 
>> It's that the flat assertion that "CityHash/SpookyHash/etc is always
>> faster" is _unwarranted_, as hardware acceleration _has a huge effect_.
> 
> Actually, the assertion is true and backed up by evidence that I
> cited. I'm not sure why you think hardware acceleration only helps
> SHA-1 and does not help CityHash or SpookyHash.

...because the hardware acceleration is in the form of instructions like 
"Update SHA1 state" ?

https://software.intel.com/en-us/articles/intel-sha-extensions

https://www.element14.com/community/servlet/JiveServlet/previewBody/41836-102-1-229511/ARM.Reference_Manual.pdf
(page 99, the SHA1{C,P,M,H,SU0,SU1} instructions)

On SPARC it's a full-on crypto coprocessor.

