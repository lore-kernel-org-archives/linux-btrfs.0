From: Jan-Frode Myklebust <janfrode@tanso.net>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Mon, 4 May 2009 20:06:51 +0200
Message-ID: <slrngvublr.95t.mykleb@janfrode.ibm.com>
References: <20090428155900.GA1722@cip.informatik.uni-erlangen.de> <49F728F6.6030307@wpkg.org> <20090428173251.GB7217@cip.informatik.uni-erlangen.de> <49F73FC9.3070607@partiallystapled.com> <49FEFBE6.40209@redhat.com> <49FEFE27.5090804@wpkg.org> <49FEFF9A.8060803@redhat.com> <20090504151518.GA13777@cip.informatik.uni-erlangen.de> <49FF11EE.2060404@redhat.com> <2a31deca0905040916s43b60cf3xdc56d365b5c1d233@mail.gmail.com> <20090504162421.GC13777@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 2009-05-04, Thomas Glanzmann <thomas@glanzmann.de> wrote:
>
>> As far as I understand, VMware already ships this "gold image" featu=
re
>> (as they call it) for Windows environments and claims it to be very
>> efficient.
>
> they call it ,,thin or shallow clones''

"thin or shallow clones" sounds more like sparse images. I believe "lin=
ked clones"
is the word for running multiple virtual machines off a single gold ima=
ge. Ref,
the "VMware View Composer" section of:

	http://www.vmware.com/products/view/whatsincluded.html
=09

> Looking at the website content, it also revealed that VMware will hav=
e a
> similiar feature for their workhorse ,,esx server'' in the upcoming
> release, however my point still stands. Ship out a service pack for
> windows and you 1.5 Gbyte of modified data that is not deduped.=20

"All desktops that are linked to a master image can be patched or updat=
ed
 simply by updating the master image, without affecting users=E2=80=99 =
settings,
 data or applications."


  -jf

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
