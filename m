Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:34082 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbbLCThA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Dec 2015 14:37:00 -0500
Received: by wmvv187 with SMTP id v187so43453729wmv.1
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Dec 2015 11:36:59 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Date: Fri, 4 Dec 2015 00:36:43 +0500
Message-ID: <CABXGCsMYdfSpZeUbWut1p542XA-L99iXM0Ero8tAFVhU9xhzkw@mail.gmail.com>
Subject: Very various speed of grep operation on btrfs partition
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Today on work I needed searching some strings in repository. Only
machine with windows was available. I am was using grep from Cygwin
for this task and I am was surprised about speed of NTFS partition.I
decided to repeat this task on my home Linux workstation.

[mikhail@localhost ~]$ time grep -rn 'float:left;display:
block;height: 24px;line-height: 1.2em;position: relative;text-align:
center;white-space: nowrap;width: 80px;'
"/home/mikhail/sources/inside/Модули интерфейса/"
/home/mikhail/sources/inside/Модули интерфейса/Активные
продажи/Темы/Разводящая группы
тем/CRMGroupTheme/CRMGroupTheme.xhtml:38:      <component
data-component="SBIS3.CORE.Button" name="addTheme" data-access="Работа
с темами CRM" class="ws-CRMGroupTheme__addTheme"
style="float:left;display: block;height: 24px;line-height:
1.2em;position: relative;text-align: center;white-space: nowrap;width:
80px;">

real 3m21.262s
user 0m0.914s
sys 0m2.288s
[mikhail@localhost ~]$ time grep -rn 'float:left;display:
block;height: 24px;line-height: 1.2em;position: relative;text-align:
center;white-space: nowrap;width: 80px;'
"/home/mikhail/sources/inside/Модули интерфейса/"
/home/mikhail/sources/inside/Модули интерфейса/Активные
продажи/Темы/Разводящая группы
тем/CRMGroupTheme/CRMGroupTheme.xhtml:38:      <component
data-component="SBIS3.CORE.Button" name="addTheme" data-access="Работа
с темами CRM" class="ws-CRMGroupTheme__addTheme"
style="float:left;display: block;height: 24px;line-height:
1.2em;position: relative;text-align: center;white-space: nowrap;width:
80px;">

real 0m49.921s
user 0m0.736s
sys 0m0.957s
[mikhail@localhost ~]$ time grep -rn 'float:left;display:
block;height: 24px;line-height: 1.2em;position: relative;text-align:
center;white-space: nowrap;width: 80px;'
"/home/mikhail/sources/inside/Модули интерфейса/"
/home/mikhail/sources/inside/Модули интерфейса/Активные
продажи/Темы/Разводящая группы
тем/CRMGroupTheme/CRMGroupTheme.xhtml:38:      <component
data-component="SBIS3.CORE.Button" name="addTheme" data-access="Работа
с темами CRM" class="ws-CRMGroupTheme__addTheme"
style="float:left;display: block;height: 24px;line-height:
1.2em;position: relative;text-align: center;white-space: nowrap;width:
80px;">

real 0m1.077s
user 0m0.667s
sys 0m0.409s
[mikhail@localhost ~]$ time grep -rn 'float:left;display:
block;height: 24px;line-height: 1.2em;position: relative;text-align:
center;white-space: nowrap;width: 80px;'
"/home/mikhail/sources/inside/Модули интерфейса/"
/home/mikhail/sources/inside/Модули интерфейса/Активные
продажи/Темы/Разводящая группы
тем/CRMGroupTheme/CRMGroupTheme.xhtml:38:      <component
data-component="SBIS3.CORE.Button" name="addTheme" data-access="Работа
с темами CRM" class="ws-CRMGroupTheme__addTheme"
style="float:left;display: block;height: 24px;line-height:
1.2em;position: relative;text-align: center;white-space: nowrap;width:
80px;">

real 0m1.062s
user 0m0.657s
sys 0m0.386s
[mikhail@localhost ~]$ time grep -rn 'float:left;display:
block;height: 24px;line-height: 1.2em;position: relative;text-align:
center;white-space: nowrap;width: 80px;'
"/home/mikhail/sources/inside/Модули интерфейса/"
/home/mikhail/sources/inside/Модули интерфейса/Активные
продажи/Темы/Разводящая группы
тем/CRMGroupTheme/CRMGroupTheme.xhtml:38:      <component
data-component="SBIS3.CORE.Button" name="addTheme" data-access="Работа
с темами CRM" class="ws-CRMGroupTheme__addTheme"
style="float:left;display: block;height: 24px;line-height:
1.2em;position: relative;text-align: center;white-space: nowrap;width:
80px;">

real 0m1.020s
user 0m0.641s
sys 0m0.373s
[mikhail@localhost ~]$ time grep -rn 'float:left;display:
block;height: 24px;line-height: 1.2em;position: relative;text-align:
center;white-space: nowrap;width: 80px;'
"/home/mikhail/sources/inside/Модули интерфейса/"
/home/mikhail/sources/inside/Модули интерфейса/Активные
продажи/Темы/Разводящая группы
тем/CRMGroupTheme/CRMGroupTheme.xhtml:38:      <component
data-component="SBIS3.CORE.Button" name="addTheme" data-access="Работа
с темами CRM" class="ws-CRMGroupTheme__addTheme"
style="float:left;display: block;height: 24px;line-height:
1.2em;position: relative;text-align: center;white-space: nowrap;width:
80px;">

real 0m0.941s
user 0m0.593s
sys 0m0.335s
[mikhail@localhost ~]$ time grep -rn 'float:left;display:
block;height: 24px;line-height: 1.2em;position: relative;text-align:
center;white-space: nowrap;width: 80px;'
"/home/mikhail/sources/inside/Модули интерфейса/"
/home/mikhail/sources/inside/Модули интерфейса/Активные
продажи/Темы/Разводящая группы
тем/CRMGroupTheme/CRMGroupTheme.xhtml:38:      <component
data-component="SBIS3.CORE.Button" name="addTheme" data-access="Работа
с темами CRM" class="ws-CRMGroupTheme__addTheme"
style="float:left;display: block;height: 24px;line-height:
1.2em;position: relative;text-align: center;white-space: nowrap;width:
80px;">

real 0m0.918s
user 0m0.594s
sys 0m0.322s
[mikhail@localhost ~]$ time grep -rn 'float:left;display:
block;height: 24px;line-height: 1.2em;position: relative;text-align:
center;white-space: nowrap;width: 80px;'
"/home/mikhail/sources/inside/Модули интерфейса/"
/home/mikhail/sources/inside/Модули интерфейса/Активные
продажи/Темы/Разводящая группы
тем/CRMGroupTheme/CRMGroupTheme.xhtml:38:      <component
data-component="SBIS3.CORE.Button" name="addTheme" data-access="Работа
с темами CRM" class="ws-CRMGroupTheme__addTheme"
style="float:left;display: block;height: 24px;line-height:
1.2em;position: relative;text-align: center;white-space: nowrap;width:
80px;">

real 0m1.053s
user 0m0.620s
sys 0m0.401s
[mikhail@localhost ~]$ time grep -rn 'float:left;display:
block;height: 24px;line-height: 1.2em;position: relative;text-align:
center;white-space: nowrap;width: 80px;'
"/home/mikhail/sources/inside/Модули интерфейса/"
/home/mikhail/sources/inside/Модули интерфейса/Активные
продажи/Темы/Разводящая группы
тем/CRMGroupTheme/CRMGroupTheme.xhtml:38:      <component
data-component="SBIS3.CORE.Button" name="addTheme" data-access="Работа
с темами CRM" class="ws-CRMGroupTheme__addTheme"
style="float:left;display: block;height: 24px;line-height:
1.2em;position: relative;text-align: center;white-space: nowrap;width:
80px;">

real 0m1.049s
user 0m0.625s
sys 0m0.411s
[mikhail@localhost ~]$ time grep -rn 'float:left;display:
block;height: 24px;line-height: 1.2em;position: relative;text-align:
center;white-space: nowrap;width: 80px;'
"/home/mikhail/sources/inside/Модули интерфейса/"
/home/mikhail/sources/inside/Модули интерфейса/Активные
продажи/Темы/Разводящая группы
тем/CRMGroupTheme/CRMGroupTheme.xhtml:38:      <component
data-component="SBIS3.CORE.Button" name="addTheme" data-access="Работа
с темами CRM" class="ws-CRMGroupTheme__addTheme"
style="float:left;display: block;height: 24px;line-height:
1.2em;position: relative;text-align: center;white-space: nowrap;width:
80px;">

real 2m51.858s
user 0m0.885s
sys 0m1.863s
[mikhail@localhost ~]$ time grep -rn 'float:left;display:
block;height: 24px;line-height: 1.2em;position: relative;text-align:
center;white-space: nowrap;width: 80px;'
"/home/mikhail/sources/inside/Модули интерфейса/"
/home/mikhail/sources/inside/Модули интерфейса/Активные
продажи/Темы/Разводящая группы
тем/CRMGroupTheme/CRMGroupTheme.xhtml:38:      <component
data-component="SBIS3.CORE.Button" name="addTheme" data-access="Работа
с темами CRM" class="ws-CRMGroupTheme__addTheme"
style="float:left;display: block;height: 24px;line-height:
1.2em;position: relative;text-align: center;white-space: nowrap;width:
80px;">

real 3m22.615s
user 0m0.876s
sys 0m2.160s
[mikhail@localhost ~]$ time grep -rn 'float:left;display:
block;height: 24px;line-height: 1.2em;position: relative;text-align:
center;white-space: nowrap;width: 80px;'
"/home/mikhail/sources/inside/Модули интерфейса/"
/home/mikhail/sources/inside/Модули интерфейса/Активные
продажи/Темы/Разводящая группы
тем/CRMGroupTheme/CRMGroupTheme.xhtml:38:      <component
data-component="SBIS3.CORE.Button" name="addTheme" data-access="Работа
с темами CRM" class="ws-CRMGroupTheme__addTheme"
style="float:left;display: block;height: 24px;line-height:
1.2em;position: relative;text-align: center;white-space: nowrap;width:
80px;">

real 1m16.100s
user 0m0.773s
sys 0m1.173s
[mikhail@localhost ~]$


>From results we see that search goes sometimes instantly less than a
second, and sometimes lasts 4 minutes. /home partition formatted in
BTRFS filesystem. I would be interested investigate what is related to
search speed. And make that search was always goes less than a second.

Here is my mount options:
UUID=82df2d84-bf54-46cb-84ba-c88e93677948 /home btrfs
subvolid=5,autodefrag,noatime,space_cache,inode_cache,nodatacow 0 0

# uname -a
Linux localhost.localdomain 4.2.6-301.fc23.x86_64+debug #1 SMP Fri Nov
20 22:07:57 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

How to start investigation?



--
Best Regards,
Mike Gavrilov.
���{.n�+�������+%�����ݶ��w��{.n�+����{���k~���^n�r���z���h����&���z��z�ޗ�+��+zf���h���~����i��������z_��j:+v���)ߣ�m
